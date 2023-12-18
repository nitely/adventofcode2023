import std/strutils
import std/sequtils
#import std/algorithm
import std/math
#import std/tables
import std/strscans
#import std/sets
#import pkg/memo
#import std/heapqueue
#import std/parseutils

type Coor = tuple[y: int, x: int]
type Instr = object
  d: Coor
  n: int
  hex: string

func coor(d: char): Coor =
  result = case d
    of 'U': (y: -1, x: 0)
    of 'D': (y: 1, x: 0)
    of 'R': (y: 0, x: 1)
    of 'L': (y: 0, x: -1)
    else: doAssert false; (y: 0, x: 0)

func parseInput(s: string): seq[Instr] =
  result = newSeq[Instr]()
  for line in s.splitLines:
    if line.len == 0:
      continue
    var d: char
    var n: int
    var hex: string
    let m = scanf(line, "$c $i (#$*)", d, n, hex)
    doAssert m
    result.add Instr(d: coor(d), n: n, hex: hex)

func vertices(s: seq[Instr]): seq[Coor] =
  result = newSeq[Coor]()
  var curr: Coor = (0, 0)
  for inst in s:
    curr = (y: curr.y+inst.n*inst.d.y, x: curr.x+inst.n*inst.d.x)
    result.add curr

# shoelance formula
func area(vs: seq[Coor]): int =
  doAssert vs.len >= 3
  result = 0
  for i in 1 .. vs.len-2:
    result += vs[i].x * (vs[i+1].y - vs[i-1].y)
  result += vs[0].x * (vs[1].y - vs[^1].y)
  result += vs[^1].x * (vs[0].y - vs[^2].y)
  result = abs(result div 2)

# Pick's theorem
func volume(vs: seq[Coor], count: int): int =
  result = area(vs) + 1 - count div 2

func day18(s: string): int =
  let insts = s.parseInput()
  let vs = vertices(insts)
  let ns = foldl(insts.mapIt(it.n), a + b, 0)
  result = volume(vs, ns) + ns

const example = """
"""

doAssert day18(example) == 62
doAssert day18(readFile("./input")) == 35401

func toCoor(c: char): Coor =
  case c
  of '0': coor('R')
  of '1': coor('D')
  of '2': coor('L')
  of '3': coor('U')
  else: doAssert false; (y: 0, x: 0)

func day18b(s: string): int =
  var insts = s.parseInput()
  for inst in mitems insts:
    inst.n = parseHexInt inst.hex[0 .. 4]
    inst.d = toCoor inst.hex[5]
  let vs = vertices(insts)
  let ns = foldl(insts.mapIt(it.n), a + b, 0)
  result = volume(vs, ns) + ns

doAssert day18b(example) == 952408144115
doAssert day18b(readFile("./input")) == 48020869073824
