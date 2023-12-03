import std/strutils

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
  result = (x-1 > 0 and s[y][x-1].isSym) or
    (x+1 < s.w and s[y][x+1].isSym) or
    (y-1 > 0 and s[y-1][x].isSym) or
    (y+1 < s.h and s[y+1][x].isSym) or
    (x-1 > 0 and y+1 < s.h and s[y+1][x-1].isSym) or
    (x+1 < s.w and y+1 < s.h and s[y+1][x+1].isSym) or
    (x-1 > 0 and y-1 > 0 and s[y-1][x-1].isSym) or
    (x+1 < s.w and y-1 > 0 and s[y-1][x+1].isSym)

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
  result = 0
  var input = readFile("./input")
  result = input.day3()

const example = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

doAssert "..123..".getNum(2) == 1
doAssert "..123..".getNum(3) == 12
doAssert "..123..".getNum(4) == 123
doAssert day3(example) == 4361
doAssert day3FromFile() == 539590
