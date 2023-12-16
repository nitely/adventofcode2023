import std/strutils
#import std/sequtils
#import std/algorithm
#import std/math
import std/tables
#import std/strscans
#import std/sets
#import pkg/memo

type Platform = object
  s: seq[string]

func h(p: Platform): int =
  result = p.s.len

func w(p: Platform): int =
  result = p.s[0].len

func parseInput(s: string): Platform =
  result = Platform(s: newSeq[string]())
  for line in s.splitLines:
    if line.len > 0:
      result.s.add line

func moveUp(p: var Platform, y, x: int) =
  doAssert p.s[y][x] == 'O'
  for y2 in countdown(y-1, 0):
    if p.s[y2][x] in {'O', '#'}:
      p.s[y][x] = '.'
      p.s[y2+1][x] = 'O'
      return
  p.s[y][x] = '.'
  p.s[0][x] = 'O'

func day14(s: string): int =
  result = 0
  var p = s.parseInput()
  for x in 0 .. p.w-1:
    for y in 0 .. p.h-1:
      if p.s[y][x] == 'O':
        moveUp(p, y, x)
  #for row in p.s:
  #  debugEcho row
  for n, row in pairs p.s:
    for cell in row:
      if cell == 'O':
        result += p.h-n

const example = """
"""

doAssert day14(example) == 136
doAssert day14(readFile("./input")) == 110821

func rotate(p: Platform): Platform =
  # rotate clockwise
  result = p
  for y in 0 .. p.h-1:
    for x in 0 .. p.w-1:
      result.s[x][p.h-1-y] = p.s[y][x]

func day14b(s: string): int =
  result = 0
  var p = s.parseInput()
  var t = newTable[Platform, int]()
  for n in 0 .. 1_000_000_000-1:
    if p in t:
      if (1_000_000_000 - n) mod (n - t[p]) == 0:
        break
    t[p] = n
    for _ in 0 .. 3:  # N,W,S,E
      for x in 0 .. p.w-1:
        for y in 0 .. p.h-1:
          if p.s[y][x] == 'O':
            moveUp(p, y, x)
      p = rotate(p)
  for n, row in pairs p.s:
    for cell in row:
      if cell == 'O':
        result += p.h-n

doAssert day14b(example) == 64
doAssert day14b(readFile("./input")) == 83516
