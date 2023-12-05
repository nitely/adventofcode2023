import std/strutils
import std/intsets
import std/math
import std/sequtils

func day4(s: string): int =
  result = 0
  for line in s.splitLines:
    if line.len == 0:
      continue
    let parts = line.split(':')[1].split('|')
    doAssert parts.len == 2
    var winNums = initIntSet()
    var myNums = initIntSet()
    let winNumsRaw = parts[0]
    let myNumsRaw = parts[1]
    for n in winNumsRaw.split(' '):
      if n.len > 0:
        winNums.incl parseInt(n)
    for n in myNumsRaw.split(' '):
      if n.len > 0:
        myNums.incl parseInt(n)
    let wonNums = myNums.intersection winNums
    if wonNums.len-1 > -1:
      result += 2 ^ (wonNums.len-1)

proc day4FromFile(): int =
  var input = readFile("./input")
  result = input.day4()

const example = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

doAssert day4(example) == 13
doAssert day4FromFile() == 25651

func day4b(s: string): int =
  result = 0
  let lines = s.splitLines
  let totalCards = lines.len-1
  var cards = repeat(1, totalCards)
  for card, line in pairs lines:
    if line.len == 0:
      continue
    let parts = line.split(':')[1].split('|')
    doAssert parts.len == 2
    var winNums = initIntSet()
    var myNums = initIntSet()
    let winNumsRaw = parts[0]
    let myNumsRaw = parts[1]
    for n in winNumsRaw.split(' '):
      if n.len > 0:
        winNums.incl parseInt(n)
    for n in myNumsRaw.split(' '):
      if n.len > 0:
        myNums.incl parseInt(n)
    let wonNums = myNums.intersection winNums
    for i in card+1 .. card+wonNums.len:
      cards[i] += cards[card]
  result = sum cards

proc day4bFromFile(): int =
  var input = readFile("./input")
  result = input.day4b()

doAssert day4b(example) == 30
doAssert day4bFromFile() == 19499881
