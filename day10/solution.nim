import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
import std/sets

type Map = object
  s: seq[string]

func w(m: Map): int =
  m.s[0].len

func h(m: Map): int =
  m.s.len

func start(m: Map): (int, int) =
  for y in 0 .. m.h-1:
    for x in 0 .. m.w-1:
      if m.s[y][x] == 'S':
        return (y, x)

func parseInput(s: string): Map =
  result = Map(
    s: s.splitLines().filterIt(it.len > 0)
  )

type Cursor = object
  x, y, steps: int
  prev: (int, int)

type TailDir = enum
  N,S,E,W
type Pipe = distinct char
const
  NS = '|'.Pipe
  EW = '-'.Pipe
  NE = 'L'.Pipe
  NW = 'J'.Pipe
  SW = '7'.Pipe
  SE = 'F'.Pipe
  NSEW = 'S'.Pipe
const
  PN = {NS, SW, SE, NSEW}
  PS = {NS, NE, NW, NSEW}
  PE = {EW, NW, SW, NSEW}
  PW = {EW, NE, SE, NSEW}

func isConn(map: Map, c: Cursor, y, x: int, td: TailDir): bool =
  let a = map.s[c.y][c.x].Pipe
  let b = map.s[y][x].Pipe
  result = case td:
    of N: a in PS and b in PN
    of S: a in PN and b in PS
    of E: a in PW and b in PE
    of W: a in PE and b in PW

iterator neighbors(map: Map, c: Cursor): (int, int) {.inline.} =
  for td in [N,S,E,W]:
    let (y0, x0) = case td
      of N: (-1,0)
      of S: (1,0)
      of E: (0,1)
      of W: (0,-1)
    let y = c.y+y0
    let x = c.x+x0
    if 0 <= y and y <= map.h-1 and
        0 <= x and x <= map.w-1 and
        map.isConn(c, y, x, td):
      yield (y, x)

iterator walk(map: Map, y0, x0: int): (int, int) {.inline.} =
  var cursors = newSeq[Cursor]()
  cursors.add Cursor(
    y: y0, x: x0, steps: 0, prev: (-1, -1)
  )
  while cursors.len > 0:
    let c = cursors.pop()
    for (y, x) in map.neighbors(c):
      if (y, x) == c.prev:
        continue
      if (y, x) != (y0, x0):
        cursors.add Cursor(
          x: x, y: y, steps: c.steps+1, prev: (c.y, c.x)
        )
      yield (y, x)

func distance(map: Map, y0, x0: int): int =
  result = -1
  var i = 0
  for (y, x) in map.walk(y0, x0):
    if (y, x) == (y0, x0):
      result = max(result, i)
      i = 0
    else:
      inc i
  result = result div 2

func day10(s: string): int =
  let map = s.parseInput
  let (y, x) = map.start()
  result = distance(map, y, x)

const example = """
"""
const example2 = """
"""
const example3 = """
"""
const example4 = """
"""

doAssert day10(example) == 4
doAssert day10(example2) == 4
doAssert day10(example3) == 8
doAssert day10(example4) == 8
doAssert day10(readFile("./input")) == 6786

func goodPipes(map: Map, y0, x0: int): seq[(int, int)] =
  result = newSeq[(int, int)]()
  var pipes = newSeq[(int, int)]()
  var loopSize = -1
  var i = 0
  for (y, x) in map.walk(y0, x0):
    pipes.add (y, x)
    if (y, x) == (y0, x0):
      if i > loopSize:
        loopSize = i
        swap result, pipes
      i = 0
      pipes.setLen 0
    else:
      inc i

func keepGoodPipes(map: Map, y0, x0: int): Map =
  result = map
  let pipes = map.goodPipes(y0, x0).toHashSet()
  for y in 0 .. map.h-1:
    for x in 0 .. map.w-1:
      if (y, x) notin pipes:
        if map.s[y][x] != '.':
          result.s[y][x] = '.'

func day10test(s: string): int =
  let map = s.parseInput
  let (y, x) = map.start()
  #for line in map.keepGoodPipes(y, x).s:
  #  debugEcho line
  result = map.keepGoodPipes(y, x).distance(y, x)

doAssert day10test(readFile("./input")) == 6786
#echo day10test(example5)

iterator directions(map: Map, c: Cursor): TailDir {.inline.} =
  for td in [N,S,E,W]:
    let (y0, x0) = case td
      of N: (-1,0)
      of S: (1,0)
      of E: (0,1)
      of W: (0,-1)
    let y = c.y+y0
    let x = c.x+x0
    if 0 <= y and y <= map.h-1 and
        0 <= x and x <= map.w-1 and
        map.isConn(c, y, x, td):
      yield td

func expand(map: Map): Map =
  # put 0's between unconnected pipes
  # and pipe extensions between connected pipes
  result = Map(s: newSeq[string]())
  # +2 extra col/row to wrap in 0's
  for y in 0 .. (map.h-1)*2+2:
    result.s.add repeat('0', map.w*2+2)
  var y2 = 1
  var x2 = 1
  for y in 0 .. map.h-1:
    for x in 0 .. map.w-1:
      result.s[y2][x2] = map.s[y][x]
      if map.s[y][x] notin {'.', '0'}:
        for dir in map.directions(Cursor(y: y, x: x)):
          case dir:
          of N: result.s[y2-1][x2] = '|'
          of S: result.s[y2+1][x2] = '|'
          of E: result.s[y2][x2+1] = '-'
          of W: result.s[y2][x2-1] = '-'
      x2 += 2
    y2 += 2
    x2 = 1

func floodFill(map: var Map) =
  doAssert map.s[0][0] == '0'
  var tiles = newSeq[(int, int)]()
  tiles.add (0, 0)
  var seen = initHashSet[(int, int)]()
  seen.incl (0, 0)
  while tiles.len > 0:
    let (y, x) = tiles.pop()
    for (i, j) in [(-1,0), (1,0), (0,1), (0,-1)]:
      let y1 = y+i
      let x1 = x+j
      if 0 <= y1 and y1 <= map.h-1 and
          0 <= x1 and x1 <= map.w-1 and
          map.s[y1][x1] in {'.', '0'} and
          (y1, x1) notin seen:
        map.s[y1][x1] = '0'
        tiles.add (y1, x1)
        seen.incl (y1, x1)
    
func day10b(s: string): int =
  let map = s.parseInput
  let (y, x) = map.start()
  let map2 = map.keepGoodPipes(y, x)
  var map3 = map2.expand()
  map3.floodFill()
  #for line in map3.s:
  #  debugEcho line
  for y in 0 .. map3.h-1:
    for x in 0 .. map3.w-1:
      if map3.s[y][x] == '.':
        result += 1

const example5 = """
"""
const example6 = """
"""
const example7 = """
"""

doAssert day10b(example5) == 4
doAssert day10b(example6) == 8
doAssert day10b(example7) == 10
doAssert day10b(readFile("./input")) == 495

echo "ok"
