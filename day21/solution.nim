import std/strutils
import std/sequtils
#import std/algorithm
import std/math
import std/tables
import std/strscans
import std/sets
#import pkg/memo
#import std/heapqueue
#import std/parseutils
#import std/deques

type Coor = tuple[y: int, x: int]
type Map = object
  s: seq[string]

func h(m: Map): int =
  m.s.len

func w(m: Map): int =
  m.s[0].len

func parseInput(s: string): Map =
  result = Map(s: s.splitLines().filterIt(it.len > 0))

func startPos(m: Map): Coor =
  for y in 0 .. m.h-1:
    for x in 0 .. m.w-1:
      if m.s[y][x] == 'S':
        return (y, x)
  doAssert false

func walk(m: Map, c: Coor, i, steps: int, seen: var HashSet[(Coor, int)]) =
  if c.y notin 0 .. m.h-1:
    return
  if c.x notin 0 .. m.w-1:
    return
  if m.s[c.y][c.x] == '#':
    return
  if (c, i) in seen:
    return
  seen.incl (c, i)
  if i == steps:
    return
  for (y, x) in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
    walk(m, (y: c.y+y, x: c.x+x), i+1, steps, seen)

func day21(s: string, steps: int): int =
  let m = s.parseInput()
  #for line in m.s:
  #  debugEcho line
  let start = m.startPos()
  #debugEcho start
  var seen = initHashSet[(Coor, int)]()
  walk(m, start, 0, steps, seen)
  result = 0
  for (c, step) in seen:
    if step == steps:
      inc result

const example = """
"""

doAssert day21(example, 6) == 16
doAssert day21(readFile("./input"), 64) == 3572

echo "ok"
