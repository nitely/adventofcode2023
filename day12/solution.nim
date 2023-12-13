import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
#import std/sets
import pkg/memo

type Record = object
  r: string
  nums: seq[int]

func parseInput(s: string): seq[Record] =
  result = newSeq[Record]()
  for line in s.splitLines():
    if line.len == 0:
      continue
    let parts = line.split(' ')
    result.add Record(
      r: parts[0],
      nums: parts[1].split(',').mapIt(parseInt it)
    )

func isFillable(s: string; num: int): bool =
  for j in 0 .. num-1:
    if j > s.len-1:
      return false
    if s[j] == '.':
      return false
  if num < s.len:
    return s[num] != '#'
  return true

proc arrangements(s: string; nums: seq[int]): int {.memoized.} =
  if nums.len == 0:
    return int('#' notin s)
  if s.len == 0:
    return 0
  if s[0] == '#':
    if isFillable(s, nums[0]):
      return arrangements(s[min(nums[0]+1, s.len) .. ^1], nums[1 .. ^1])
    else:
      return 0
  if s[0] == '?':
    if isFillable(s, nums[0]):
      return
        arrangements(s[min(nums[0]+1, s.len) .. ^1], nums[1 .. ^1]) +
        arrangements(s[1 .. ^1], nums)
    else:
      return arrangements(s[1 .. ^1], nums)
  doAssert s[0] == '.'
  return arrangements(s[1 .. ^1], nums)

proc day12(s: string): int =
  let records = s.parseInput()
  #debugEcho records
  result = 0
  for r in records:
    result += arrangements(r.r, r.nums)

const example = """
#.#.### 1,1,3
.#...#....###. 1,1,3
.#.###.#.###### 1,3,1,6
####.#...#... 4,1,1
#....######..#####. 1,6,5
.###.##....# 3,2,1
"""
const example2 = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""

doAssert day12(example) == 6
doAssert day12(example2) == 21
doAssert day12(readFile("./input")) == 6958

proc day12b(s: string): int =
  let records = s.parseInput()
  #debugEcho records
  result = 0
  for r in records:
    var s = r.r
    for _ in 0 .. 3:
      s &= "?" & r.r
    var nums = r.nums
    for i in 0 .. 3:
      nums.add r.nums
    result += arrangements(s, nums)

doAssert day12b(example) == 6
doAssert day12b(example2) == 525152
doAssert day12b(readFile("./input")) == 6555315065024

echo "ok"
