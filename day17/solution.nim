import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
import std/sets
#import pkg/memo
import std/heapqueue

type Map = object
  s: seq[seq[int]]

func h(p: Map): int =
  result = p.s.len

func w(p: Map): int =
  result = p.s[0].len

func parseInput(s: string): Map =
  result = Map(
    s: s.splitLines().filterIt(it.len > 0).mapIt(it.mapIt(it.ord - '0'.ord))
  )

type Coor = tuple[y: int, x: int]
proc `+`(a, b: Coor): Coor = (y: a.y+b.y, x: a.x+b.x)
type Qval = tuple[w: int, c: Coor, p: Coor, i: int]
proc `<`(a, b: Qval): bool = a.w < b.w

# dijkstra
# there may be an off by one error for part2
proc walk(s: Map, minSteps = 0, maxSteps = 3): int =
  let start = (y: 0,x: 0)
  let goal = (y: s.h-1, x: s.w-1)
  var q = initHeapQueue[Qval]()
  q.push (0, start, start, minSteps)
  #q.push (s.s[0][1], (y: 0, x: 1), start, 0)
  #q.push (s.s[1][0], (y: 1, x: 0), start, 0)
  var seen = initHashSet[(Coor, Coor, int)]()
  while q.len > 0:
    let qv = q.pop()
    if qv.c == goal and qv.i >= minSteps-1:
      return qv.w
    if (qv.c, qv.p, qv.i) in seen:
      continue
    seen.incl (qv.c, qv.p, qv.i)
    for t in [(y: 1, x: 0), (y: -1, x: 0), (y: 0, x: 1), (y: 0, x: -1)]:
      let i = if qv.c == qv.p + t: qv.i+1 else: 0  # same dir or not
      if i == maxSteps:
        continue
      if qv.i < minSteps-1 and i == 0:
        continue
      let (y, x) = qv.c + t
      if qv.p == (y: y, x: x):  # backwards
        continue
      if y notin 0 .. s.h-1:
        continue
      if x notin 0 .. s.w-1:
        continue
      q.push (qv.w+s.s[y][x], (y: y, x: x), qv.c, i)

proc day17(s: string): int =
  let map = s.parseInput()
  result = walk(map)

const example = """
"""

doAssert day17(example) == 102
doAssert day17(readFile("./input")) == 963

proc day17b(s: string): int =
  let map = s.parseInput()
  result = walk(map, minSteps = 4, maxSteps = 10)

doAssert day17b(example) == 94
doAssert day17b(readFile("./input")) == 1178

echo "ok"
