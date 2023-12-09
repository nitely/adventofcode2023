import std/strutils
import std/sequtils
#import std/algorithm
import std/math
import std/tables
import std/strscans

const example = """

"""

type MapVal = object
  left, right: string
type Map = object
  t: Table[string, MapVal]
  steps: string

func parseInput(s: string): Map =
  result = Map(
    t: initTable[string, MapVal](),
    steps: ""
  )
  let lines = s.splitLines()
  doAssert lines[0].len > 0
  result.steps = lines[0]
  var elm = ""
  var left = ""
  var right = ""
  for line in lines:
    if scanf(line, "$* = ($*, $*)", elm, left, right):
      doAssert elm notin result.t
      result.t[elm] = MapVal(left: left, right: right)
    else:
      doAssert '=' notin line

proc getDist(map: Map, first:string, isLast: proc(s: string): bool): int =
  result = 0
  var curr = first
  var i = 0
  while not isLast(curr):
    if map.steps[i] == 'L':
      curr = map.t[curr].left
    else:
      doAssert map.steps[i] == 'R'
      curr = map.t[curr].right
    i = (i+1) mod map.steps.len
    inc result

proc getDist(map: Map, first, last: string): int =
  result = getDist(map, first, proc(s: string): bool = s == last)

proc day8(s: string): int =
  var map = s.parseInput()
  result = getDist(map, "AAA", "ZZZ")

proc day8FromFile(): int =
  var input = readFile("./input")
  result = input.day8()

doAssert day8(example) == 6
doAssert day8FromFile() == 19667

const example2 = """

"""

proc day8b(s: string): int =
  result = 0
  var map = s.parseInput()
  var dists = newSeq[int]()
  for k in map.t.keys:
    if k[^1] == 'A':
      dists.add getDist(map, k, proc(s: string): bool = s[^1] == 'Z')
  #debugEcho dists
  # least common multiple of path distances
  #
  # This only works because cycle len for every path
  # is the same as the len from A to Z, and there is only
  # one single Z in every cycle. Otherwise we need to find
  # the start of cycle and add A to start len to the result. If
  # there are multiple Z in a cycle, LCM gives a possible answer
  # but not necessarily the shortest path I think
  result = lcm(dists)

doAssert day8b(example2) == 6
doAssert day8b(readFile("./input")) == 19185263738117

echo "ok"
