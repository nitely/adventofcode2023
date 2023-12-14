import std/strutils
#import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
#import std/sets

type Pattern = object
  s: seq[string]

func h(p: Pattern): int =
  result = p.s.len

func w(p: Pattern): int =
  result = p.s[0].len

func parseInput(s: string): seq[Pattern] =
  result = newSeq[Pattern]()
  result.add Pattern(s: newSeq[string]())
  for line in s.splitLines:
    if line.len == 0:
      doAssert result[^1].s.len > 0
      result.add Pattern(s: newSeq[string]())
      continue
    result[^1].s.add line
  if result[^1].s.len == 0:
    discard result.pop()
  doAssert result[^1].s.len > 0

func cmp(a, b: string, smudges: var int): bool =
  doAssert a.len == b.len
  var i = 0
  while i < a.len:
    if a[i] != b[i]:
      if smudges == 0:
        return false
      dec smudges
    inc i
  return true

func toString(p: Pattern; col: int): string =
  result = ""
  for s in p.s:
    result.add s[col]

func vCmp(p: Pattern, colA, colB, smudges: int): int =
  result = -1
  var nextA = colA
  var nextB = colB
  var smudges = smudges
  while nextA < nextB:
    if not cmp(p.toString(nextA), p.toString(nextB), smudges):
      break
    inc nextA
    dec nextB
  if nextA > nextB:
    result = nextA

func vLine(p: Pattern, smudges = 0, skip = -1): int =
  result = 0
  # anchor start
  for colB in countdown(p.w-1, 0):
    result = vCmp(p, 0, colB, smudges)
    if result != -1 and result != skip:
      return
  # anchor end
  for colA in 0 .. p.w-1:
    result = vCmp(p, colA, p.w-1, smudges)
    if result != -1 and result != skip:
      return
  result = max(0, result)
  if result == skip:
    return 0

func hCmp(p: Pattern; rowA, rowB, smudges: int): int =
  result = -1
  var nextA = rowA
  var nextB = rowB
  var smudges = smudges
  while nextA < nextB:
    if not cmp(p.s[nextA], p.s[nextB], smudges):
      break
    inc nextA
    dec nextB
  if nextA > nextB:
    result = nextA * 100

func hLine(p: Pattern, smudges = 0, skip = -1): int =
  result = 0
  for rowB in countdown(p.h-1, 0):
    result = hCmp(p, 0, rowB, smudges)
    if result != -1 and result != skip:
      return
  for rowA in 0 .. p.h-1:
    result = hCmp(p, rowA, p.h-1, smudges)
    if result != -1 and result != skip:
      return
  result = max(0, result)
  if result == skip:
    return 0

func day13(s: string): int =
  result = 0
  let pats = s.parseInput()
  for pat in pats:
    result += vLine(pat) + hLine(pat)

const example = """

"""
const example2 = """

"""

doAssert day13(example) == 5
doAssert day13(example2) == 400
doAssert day13(readFile("./input")) == 36041

# flipping a cell and then the opposite one
# will return the same reflection line twice
# also the cell needs to be part of the
# compared cells, otherwise the original line
# will match for every cell outside of it
# and some other issues that make flipping cells
# a bad idea
func day13b(s: string): int =
  result = 0
  let pats = s.parseInput()
  for pat in pats:
    result +=
      vLine(pat, smudges = 1, skip = vLine(pat)) +
      hLine(pat, smudges = 1, skip = hLine(pat))

doAssert day13b(example) == 300
doAssert day13b(example2) == 100
doAssert day13b(readFile("./input")) == 35915

echo "ok"
