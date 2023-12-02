import std/strutils

func digits(s: string): int =
  var digit1 = -1
  var digit2 = -1
  for c in s:
    if c in '0' .. '9':
      let digit = c.int8 - '0'.int8
      if digit1 == -1:
        digit1 = digit
      digit2 = digit
  result = digit1 * 10 + digit2

proc day1(): int =
  let input = readFile("./input")
  for line in input.splitLines:
    if line.len > 0:
      result += digits line

doAssert "1abc2".digits == 12
doAssert "pqr3stu8vwx".digits == 38
doAssert "a1b2c3d4e5f".digits == 15
doAssert "treb7uchet".digits == 77
echo day1()

func replaceWords(s: string): string =
  # hack for overlapped words
  const replacements = [
    ("one", "one1one"), ("two", "two2two"),
    ("three", "three3three"), ("four", "four4four"),
    ("five", "five5five"), ("six", "six6six"),
    ("seven", "seven7seven"), ("eight", "eight8eight"),
    ("nine", "nine9nine")]
  result = s
  for (a, b) in items replacements:
    result = result.replace(a, b)

proc day1b(): int =
  var input = readFile("./input")
  for line in input.splitLines:
    if line.len > 0:
      result += line.replaceWords.digits

doAssert "two1nine".replaceWords.digits == 29
doAssert "eightwothree".replaceWords.digits == 83
doAssert "abcone2threexyz".replaceWords.digits == 13
doAssert "xtwone3four".replaceWords.digits == 24
doAssert "4nineeightseven2".replaceWords.digits == 42
doAssert "zoneight234".replaceWords.digits == 14
doAssert "7pqrstsixteen".replaceWords.digits == 76
echo day1b()
