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
