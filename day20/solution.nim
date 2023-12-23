import std/strutils
import std/sequtils
#import std/algorithm
import std/math
import std/tables
import std/strscans
#import std/sets
#import pkg/memo
#import std/heapqueue
#import std/parseutils
import std/deques

type Pulse = enum
  pHigh, pLow
type ModName = string
type ModTyp = enum
  mtBroadcaster, mtFlipFlop, mtConjuntion

func toModTyp(c: char): ModTyp =
  case c:
  of '%': mtFlipFlop
  of '&': mtConjuntion
  of 'b': mtBroadcaster
  else: doAssert false; mtBroadcaster

type FlipOnOff = enum
  fOff, fOn

func switch(f: FlipOnOff): FlipOnOff =
  case f:
  of fOn: fOff
  of fOff: fOn

type Mod = object
  typ: ModTyp
  dest: seq[ModName]
  flip: FlipOnOff
  conj: Table[ModName, Pulse]
type ModConfig = object
  m: Table[ModName, Mod]

func parseInput(s: string): ModConfig =
  result = ModConfig(
    m: initTable[ModName, Mod]()
  )
  for line in s.splitLines:
    if line.len == 0:
      continue
    var typ: char
    var name = ""
    var dests = ""
    let m = scanf(line, "$c$* -> $*", typ, name, dests)
    doAssert m
    doAssert name notin result.m
    result.m[name] = Mod(
      typ: toModTyp typ,
      dest: dests.split(',').mapIt(it.strip),
      flip: fOff,
      conj: initTable[ModName, Pulse]()
    )

func fillConj(mc: var ModConfig) =
  for k, v in mpairs mc.m:
    for d in v.dest:
      if d notin mc.m:
        continue
      if mc.m[d].typ == mtConjuntion:
        mc.m[d].conj[k] = pLow

type QueueVal = tuple[n: ModName, pn: ModName, p: Pulse]

func process(mc: var ModConfig, i: int): (int, int) =
  template m: untyped = mc.m[n]
  var resLow = 0
  var resHigh = 0
  var q = initDeque[QueueVal]()
  q.addFirst ("roadcaster", "", pLow)
  while q.len > 0:
    let (n, pn, p) = q.popLast()
    case p:
    of pLow: inc resLow
    of pHigh: inc resHigh
    if n notin mc.m:
      continue
    case m.typ:
    of mtBroadcaster:
      for d in m.dest:
        q.addFirst (d, n, p)
    of mtFlipFlop:
      if p == pLow:
        m.flip = m.flip.switch()
        for d in m.dest:
          case m.flip
          of fOn: q.addFirst (d, n, pHigh)
          of fOff: q.addFirst (d, n, pLow)
    of mtConjuntion:
      doAssert pn in m.conj
      if n == "kl":  # kl -> xt
        for k, v in pairs mc.m["kl"].conj:
          if v == pHigh:
            debugEcho k, " ", i
            discard
      m.conj[pn] = p
      let isHigh = values(m.conj).toSeq.allIt(it == pHigh)
      for d in m.dest:
        if isHigh:
          q.addFirst (d, n, pLow)
        else:
          q.addFirst (d, n, pHigh)
  result = (resLow, resHigh)

func day20(s: string): int =
  var mc = s.parseInput()
  fillConj mc
  var resLow = 0
  var resHigh = 0
  for _ in 0 .. 1000-1:
    let (lo, hi) = process(mc, 0)
    resLow += lo
    resHigh += hi
  result = resLow * resHigh

const example = """
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
"""
const example2 = """
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
"""

doAssert day20(example) == 32000000
doAssert day20(example2) == 11687500
doAssert day20(readFile("./input")) == 980457412

func day20b(s: string): int =
  var mc = s.parseInput()
  fillConj mc
  for i in 1 .. 10_000:
    discard process(mc, i)

echo day20b(readFile("./input"))
echo lcm(@[3767,3923,3931,4007])
#232774988886497

echo "ok"
