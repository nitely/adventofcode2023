import std/strutils
import std/sequtils
import std/strscans

type MapVal = object
  dst, src, ln: int
type Almanac = object
  seeds: seq[int]
  maps: seq[seq[MapVal]]

func parseAlmanac(s: string): Almanac =
  result = Almanac(
    seeds: newSeq[int](),
    maps: newSeq[seq[MapVal]]()
  )
  let lines = s.splitLines()
  var i = 0
  while i < lines.len:
    if lines[i].startsWith "seeds":
      result.seeds = lines[i]
        .split(":")[1]
        .strip
        .split(' ')
        .mapIt(parseInt(it))
    elif "map" in lines[i]:
      inc i
      result.maps.add newSeq[MapVal]()
      while lines[i].len > 0:
        var mv = MapVal()
        let m = scanf(lines[i], "$i $i $i", mv.dst, mv.src, mv.ln)
        doAssert m
        result.maps[^1].add mv
        inc i
    else:
      doAssert lines[i].len == 0
    inc i

func day5(s: string): int =
  let almanac = parseAlmanac s
  result = int.high
  #debugEcho seeds
  #debugEcho maps
  for seed in almanac.seeds:
    var ss = seed
    for m in almanac.maps:
      for v in m:
        if v.src <= ss and ss <= v.src+v.ln-1:
          ss = v.dst - v.src + ss
          break
    #debugEcho ss
    result = min(result, ss)

proc day5FromFile(): int =
  var input = readFile("./input")
  result = input.day5()

const example = """

"""

doAssert day5(example) == 35
doAssert day5FromFile() == 111627841

iterator zip(s: seq[int]): (int, int) =
  var i = 0
  while i < s.len:
    yield (s[i], s[i+1])
    i += 2

func day5b(s: string): int =
  let almanac = parseAlmanac s
  result = int.high
  for seedStart, ln in zip almanac.seeds:
    for seed in seedStart .. seedStart+ln-1:
      var ss = seed
      for m in almanac.maps:
        for v in m:
          if v.src <= ss and ss <= v.src+v.ln-1:
            ss = v.dst - v.src + ss
            break
      result = min(result, ss)

proc day5bFromFile(): int =
  var input = readFile("./input")
  result = input.day5b()

doAssert day5b(example) == 46
doAssert day5bFromFile() == 69323688
