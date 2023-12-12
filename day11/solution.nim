import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
#import std/sets

type Universe = object
  s: seq[string]

func w(m: Universe): int =
  m.s[0].len

func h(m: Universe): int =
  m.s.len

func parseInput(s: string): Universe =
  result = Universe(
    s: s.splitLines().filterIt(it.len > 0)
  )

type ExpFactor = object
  y, x: seq[int]

func expandFactors(u: Universe, factor: int): ExpFactor =
  ## return offsets of empty lines for every y/col and x/row
  ## empty lines counts as factor number of lines
  doAssert factor > 0
  result = ExpFactor(
    y: repeat(0, u.h),
    x: repeat(0, u.w)
  )
  var yf = 0
  for y in 0 .. u.h-1:
    if u.s[y].allIt(it == '.'):
      inc(yf, factor-1)
    result.y[y] = yf
  var xf = 0
  for x in 0 .. u.w-1:
    if u.s.allIt(it[x] == '.'):
      inc(xf, factor-1)
    result.x[x] = xf

func distance(x0, y0, x1, y1: int): int =
  ## manhattan distance
  result = abs(x0 - x1) + abs(y0 - y1)

func day11b(s: string, factor = 2): int =
  let univ = s.parseInput()
  let ef = expandFactors(univ, factor)
  var galaxies = newSeq[(int, int)]()
  for y in 0 .. univ.h-1:
    for x in 0 .. univ.w-1:
      if univ.s[y][x] == '#':
        galaxies.add (y+ef.y[y], x+ef.x[x])
  for (y0, x0) in galaxies:
    for (y1, x1) in galaxies:
      if (y0, x0) != (y1, x1):
        result += distance(y0, x0, y1, x1)
  # one way only
  result = result div 2

const example = """

"""

doAssert day11b(example) == 374
doAssert day11b(readFile("./input")) == 9556712
doAssert day11b(example, 10) == 1030
doAssert day11b(example, 100) == 8410
doAssert day11b(readFile("./input"), 1_000_000) == 678626199476

echo "ok"