import std/strutils
import std/sequtils
import std/intsets

type
  Schema = seq[string]

func h(s: Schema): int =
  s.len

func w(s: Schema): int =
  s[0].len

func isSym(c: char): bool =
  result = c notin {'.', '0' .. '9'}

func isValid(s: Schema, x, y: int): bool =
  doAssert s[y][x] in {'0' .. '9'}
  result = false
  for yy in max(0, y-1) .. min(s.h-1, y+1):
    for xx in max(0, x-1) .. min(s.w-1, x+1):
      result = result or s[yy][xx].isSym

func getNum(s: string, i: int): int =
  # get num from ending digit
  var start = i
  for j in countdown(i, 0):
    if s[j] notin {'0' .. '9'}:
      break
    start = j
  for j in start .. i:
    result = result * 10 + s[j].ord - '0'.ord
  #debugEcho result

func day3(s: string): int =
  var ss: Schema = newSeq[string]()
  for line in s.splitLines:
    if line.len > 0:
      ss.add line
  for y in 0 .. ss.h-1:
    var isPart = false
    for x in 0 .. ss.w-1:
      if ss[y][x] notin {'0' .. '9'}:
        if isPart:
          result += getNum(ss[y], x-1)
        isPart = false
      else:
        isPart = isPart or isValid(ss, x, y)
    if isPart:
      result += getNum(ss[y], ss[y].len-1)

proc day3FromFile(): int =
  var input = readFile("./input")
  result = input.day3()

const example = """

"""

doAssert "..123..".getNum(2) == 1
doAssert "..123..".getNum(3) == 12
doAssert "..123..".getNum(4) == 123
doAssert day3(example) == 4361
doAssert day3FromFile() == 539590

type
  PartsTable = seq[seq[int]]
    ## Table where every digit cell has its part ID

func getParts(pt: PartsTable, y, x: int): IntSet =
  result = initIntSet()
  for yy in max(0, y-1) .. min(pt.len-1, y+1):
    for xx in max(0, x-1) .. min(pt[0].len-1, x+1):
      if pt[yy][xx] != -1:
        result.incl pt[yy][xx]

func partsTableFromSchema(s: Schema): PartsTable =
  result = newSeq[seq[int]]()
  for y in 0 .. s.h-1:
    result.add repeat(-1, s.w)
  for y in 0 .. s.h-1:
    var start = int.high
    var part = 0
    for x in 0 .. s.w-1:
      if s[y][x] in {'0' .. '9'}:
        start = min(start, x)
        part = part * 10 + s[y][x].ord - '0'.ord
      elif start != int.high:
        for xx in start .. x-1:
          result[y][xx] = part
        start = int.high
        part = 0
    if start != int.high:
      for xx in start .. s.w-1:
        result[y][xx] = part

func day3b(s: string): int =
  result = 0
  var ss: Schema = newSeq[string]()
  for line in s.splitLines:
    if line.len > 0:
      ss.add line
  let partsTable = partsTableFromSchema ss
  for y in 0 .. ss.h-1:
    for x in 0 .. ss.w-1:
      if ss[y][x] == '*':
        let parts = partsTable.getParts(y, x)
        if parts.len == 2:
          result += foldl(parts, a * b, 1)

proc day3bFromFile(): int =
  var input = readFile("./input")
  result = input.day3b()

doAssert day3b(example) == 467835
doAssert day3bFromFile() == 80703636
