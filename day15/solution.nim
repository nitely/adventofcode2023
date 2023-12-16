import std/strutils
#import std/sequtils
#import std/algorithm
#import std/math
#import std/tables
#import std/strscans
#import std/sets
#import pkg/memo

func parseInput(s: string): seq[string] =
  result = newSeq[string]()
  for line in s.splitLines:
    if line.len > 0:
      result.add line.split(',')

func hash(s: string): int =
  result = 0
  for c in s:
    result += c.ord
    result *= 17
    result = result mod 256

func day15(s: string): int =
  result = 0
  let m = s.parseInput
  for kv in m:
    result += hash(kv)

const example = """
"""

doAssert day15(example) == 1320
doAssert day15(readFile("./input")) == 506437

type Box = seq[(string, int)]

func remove(s: var Box, k: string) =
  var i = 0
  var j = 0
  while i < s.len:
    if s[i][0] == k:
      inc i
    else:
      s[j] = s[i]
      inc j
      inc i
  s.setLen(j)

func incl(s: var Box, k: string, v: int) =
  var replaced = false
  for (k2, v2) in mitems s:
    if k2 == k:
      v2 = v
      replaced = true
  if not replaced:
    s.add (k, v)

func day15b(s: string): int =
  result = 0
  let m = s.parseInput
  var boxes = newSeq[Box](256)
  for i in 0 .. boxes.len-1:
    boxes.add newSeq[(string, int)]()
  for kv in m:
    let splitBy = if '-' in kv: '-' else: '='
    let parts = kv.split(splitBy)
    let k = parts[0]
    let v = parts[1]
    let boxNum = hash(k)
    if v.len == 0:
      remove(boxes[boxNum], k)
    else:
      incl(boxes[boxNum], k, parseInt v)
  #debugEcho boxes
  for box in 0 .. boxes.len-1:
    for i, (k, v) in pairs boxes[box]:
      result += (box+1) * (i+1) * v

doAssert day15b(example) == 145
doAssert day15b(readFile("./input")) == 288521

echo "ok"
