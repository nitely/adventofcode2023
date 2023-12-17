import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
import std/sets
#import pkg/memo

type Contraption = object
  s: seq[string]

func h(p: Contraption): int =
  result = p.s.len

func w(p: Contraption): int =
  result = p.s[0].len

func parseInput(s: string): Contraption =
  result = Contraption(
    s: s.splitLines().filterIt(it.len > 0)
  )

type Dir = enum
  dirUp, dirLeft, dirDown, dirRight

type Beam = object
  dir: Dir
  y, x: int

func energize(
  ctr: Contraption;
  result: var Contraption;
  seen: var HashSet[Beam];
  beam: Beam
) =
  template call(beam: Beam): untyped =
    energize(ctr, result, seen, beam)
  template goRight: untyped =
    call Beam(dir: dirRight, y: beam.y, x: beam.x+1)
  template goLeft: untyped =
    call Beam(dir: dirLeft, y: beam.y, x: beam.x-1)
  template goUp: untyped =
    call Beam(dir: dirUp, y: beam.y-1, x: beam.x)
  template goDown: untyped =
    call Beam(dir: dirDown, y: beam.y+1, x: beam.x)
  if beam.x notin 0 .. ctr.w-1:
    return
  if beam.y notin 0 .. ctr.h-1:
    return
  if beam in seen:
    return
  seen.incl beam
  result.s[beam.y][beam.x] = '#'
  let tile = ctr.s[beam.y][beam.x]
  case beam.dir:
  of dirUp:
    if tile in {'-', '/'}: goRight
    if tile in {'-', '\\'}: goLeft
    if tile in {'.', '|'}: goUp
  of dirLeft:
    if tile in {'|', '/'}: goDown
    if tile in {'|', '\\'}: goUp
    if tile in {'.', '-'}: goLeft
  of dirDown:
    if tile in {'-', '/'}: goLeft
    if tile in {'-', '\\'}: goRight
    if tile in {'.', '|'}: goDown
  of dirRight:
    if tile in {'|', '/'}: goUp
    if tile in {'|', '\\'}: goDown
    if tile in {'.', '-'}: goRight

func countEnergizedTiles(
  ctr: Contraption;
  beam: Beam
): int =
  result = 0
  var ctrResult = ctr
  var seen = initHashSet[Beam]()
  energize(ctr, ctrResult, seen, beam)
  for row in ctrResult.s:
    #debugEcho row
    for cell in row:
      if cell == '#':
        inc result

func day16(s: string): int =
  let ctr = s.parseInput()
  result = countEnergizedTiles(ctr, Beam(dir: dirRight, y: 0, x: 0))

const example = """

"""

doAssert day16(example) == 46
doAssert day16(readFile("./input")) == 7884

func day16b(s: string): int =
  let ctr = s.parseInput()
  result = 0
  for y in 0 .. ctr.h-1:
    for x in 0 .. ctr.w-1:
      var dir: Dir
      if x == 0:
        dir = dirRight
      elif x == ctr.w-1:
        dir = dirLeft
      elif y == 0:
        dir = dirDown
      elif y == ctr.h-1:
        dir = dirUp
      else:
        continue
      let count = countEnergizedTiles(ctr, Beam(dir: dir, y: y, x: x))
      result = max(result, count)

doAssert day16b(example) == 51
doAssert day16b(readFile("./input")) == 8185

echo "ok"
