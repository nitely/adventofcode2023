import std/strutils
import std/sequtils

const example = """
"""
const input = """
"""

func parseNums(s: string): seq[int] =
  doAssert ':' in s
  result = s
    .split(':')[1]
    .split(' ')
    .filterIt(it.len > 0)
    .mapIt(parseInt(it))

func day6(s: string): int =
  let lines = s.strip.splitLines()
  doAssert lines.len == 2
  let times = lines[0].parseNums()
  let dists = lines[1].parseNums()
  doAssert times.len > 0
  doAssert times.len == dists.len
  result = 1
  for i in 0 .. times.len-1:
    var count = 0
    for pushTime in 0 .. times[i]:
      let moveTime = times[i] - pushTime
      let dist = moveTime * pushTime
      if dist > dists[i]:
        inc count
    #result = max(result, result * count)
    result = result * count

doAssert day6(example) == 288
doAssert day6(input) == 170000

func day6b(s: string): int =
  let lines = s.strip.splitLines()
  doAssert lines.len == 2
  let time = lines[0].replace(" ", "").split(':')[1].parseInt
  let dist = lines[1].replace(" ", "").split(':')[1].parseInt
  result = 1
  var count = 0
  for pushTime in 0 .. time:
    let moveTime = time - pushTime
    let distX = moveTime * pushTime
    if distX > dist:
      inc count
  #result = max(result, result * count)
  result = result * count

doAssert day6b(example) == 71503
doAssert day6b(input) == 20537782

# I think we can do a *right* binary search
# by multiplying by 2 each time
# to improve from linear time to log time
# but meh
