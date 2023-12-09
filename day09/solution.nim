import std/strutils
import std/sequtils
import std/algorithm
import std/math
import std/tables
import std/strscans

const example = """

"""

func parseInput(s: string): seq[seq[int]] =
  result = s
    .splitLines
    .filterIt(it.len > 0)
    .mapIt(it.split(' ').mapIt(parseInt it))

iterator zip(s: seq[int]): (int, int) {.inline.} =
  var i = 0
  while i < s.len-1:
    yield (s[i], s[i+1])
    i += 1

func extrapolate(report: seq[seq[int]]): int =
  var curr = newSeq[int]()
  var currTmp = newSeq[int]()
  var lastNums = newSeq[int]()
  for history in report:
    curr = history
    lastNums.setLen 0
    lastNums.add curr[^1]
    while not curr.allIt(it == 0):
      currTmp.setLen 0
      for valA, valB in zip curr:
        currTmp.add valB - valA
      swap curr, currTmp
      #debugEcho curr
      lastNums.add curr[^1]
    #debugEcho lastNums
    var x = 0
    for n in lastNums.reversed:
      x = n + x
    result += x

func day9(s: string): int =
  var report = parseInput(s)
  result = report.extrapolate()

doAssert day9(example) == 114
doAssert day9(readFile("./input")) == 1581679977

func reverse(report: var seq[seq[int]]) =
  for h in mitems report:
    h.reverse()

func day9b(s: string): int =
  var report = parseInput(s)
  report.reverse()
  result = report.extrapolate()

doAssert day9b(example) == 2
doAssert day9b(readFile("./input")) == 889

echo "ok"