import std/strutils
import std/sequtils
#import std/algorithm
#import std/math
import std/tables
import std/strscans
#import std/sets
#import pkg/memo
#import std/heapqueue
#import std/parseutils

type Op = enum
  opGt, opLt

func toOp(c: char): Op =
  case c
  of '>': opGt
  of '<': opLt
  else: doAssert false; opGt

type Rvar = enum
  rvarX, rvarM, rvarA, rvarS

func toRvar(c: char): Rvar =
  case c
  of 'x': rvarX
  of 'm': rvarM
  of 'a': rvarA
  of 's': rvarS
  else: doAssert false; rvarX

type WfName = string
type Rule = object
  op: Op
  rvar: Rvar
  val: int
  next: WfName

func cmp(a, b: int, op: Op): bool =
  case op
  of opGt: a > b
  of opLt: a < b

type Workflow = object
  rules: seq[Rule]
  els: WfName
type Workflows = Table[WfName, Workflow]
type Rating = object
  x, m, a, s: int
type Ratings = seq[Rating]

func parseInput(s: string): tuple[wf: Workflows, rt: Ratings] =
  result = (
    wf: initTable[WfName, Workflow](),
    rt: newSeq[Rating]()
  )
  let lines = s.splitLines
  var scm = false
  var i = 0
  while i < s.len:
    if lines[i].len == 0:
      break
    var rules = ""
    var wfName = ""
    scm = scanf(lines[i], "$*{$*}", wfName, rules)
    doAssert scm
    var wf = Workflow(rules: newSeq[Rule]())
    for rule in rules.split(','):
      if ':' notin rule:
        wf.els = rule
      else:
        let cond = rule.split(':')
        doAssert cond.len == 2
        wf.rules.add Rule(
          rvar: toRvar cond[0][0],
          op: toOp cond[0][1],
          val: parseInt cond[0][2 .. ^1],
          next: cond[1]
        )
    doAssert wfName notin result.wf
    result.wf[wfName] = wf
    inc i
  inc i
  while i < s.len:
    if lines[i].len == 0:
      break
    var x, m, a, s: int
    scm = scanf(lines[i], "{x=$i,m=$i,a=$i,s=$i}", x, m, a, s)
    doAssert scm
    result.rt.add Rating(x: x, m: m, a: a, s: s)
    inc i

func eval(r: Rating, rule: Rule): bool =
  case rule.rvar
  of rvarX: cmp(r.x, rule.val, rule.op)
  of rvarM: cmp(r.m, rule.val, rule.op)
  of rvarA: cmp(r.a, rule.val, rule.op)
  of rvarS: cmp(r.s, rule.val, rule.op)

func eval(r: Rating, wfs: Workflows): bool =
  var curr = "in"
  var reval = false
  while curr notin ["A", "R"]:
    reval = false
    let wf = wfs[curr]
    for rule in wf.rules:
      reval = eval(r, rule)
      if reval:
        curr = rule.next
        break
    if not reval:
      curr = wf.els
  return curr == "A"

func day19(s: string): int =
  result = 0
  let (wfs, rts) = s.parseInput()
  #debugEcho wfs
  #debugEcho rts
  for rt in rts:
    if eval(rt, wfs):
      result += rt.x + rt.m + rt.a + rt.s

const example = """
"""

doAssert day19(example) == 19114
doAssert day19(readFile("./input")) == 377025

type Rating2 = object
  x, m, a, s: Slice[int]

func isValid(rt: Rating2): bool =
  result = rt.x.a <= rt.x.b and
    rt.m.a <= rt.m.b and
    rt.a.a <= rt.a.b and
    rt.s.a <= rt.s.b

func toInclusive(rtv: var Slice[int], r: Rule) =
  ## Set the range that will match the rule
  case r.op
  of opGt: rtv.a = max(rtv.a, r.val+1)
  of opLt: rtv.b = min(rtv.b, r.val-1)

func toExclusive(rtv: var Slice[int], r: Rule) =
  ## Set the range that won't match the rule
  case r.op
  of opGt: rtv.b = min(rtv.b, r.val)
  of opLt: rtv.a = max(rtv.a, r.val)

func combs(rt: Rating2): int =
  let vals = [rt.x, rt.m, rt.a, rt.s]
  #if vals.allIt(it.len == 0):
  #  return 0
  result = 1
  for r in vals:
    if r.len > 0:
      result *= r.len

func walk(wfs: Workflows, wfn: WfName, rt: Rating2): int =
  #if not isValid(rt):
  #  return 0
  if wfn == "R":
    return 0
  if wfn == "A":
    return combs(rt)
  result = 0
  let wf = wfs[wfn]
  var rtpv = rt
  for rule in wf.rules:
    var rtpv2 = rtpv
    case rule.rvar
    of rvarX: toInclusive(rtpv.x, rule); toExclusive(rtpv2.x, rule)
    of rvarM: toInclusive(rtpv.m, rule); toExclusive(rtpv2.m, rule)
    of rvarA: toInclusive(rtpv.a, rule); toExclusive(rtpv2.a, rule)
    of rvarS: toInclusive(rtpv.s, rule); toExclusive(rtpv2.s, rule)
    result += walk(wfs, rule.next, rtpv)
    swap rtpv, rtpv2
  result += walk(wfs, wf.els, rtpv)

func day19b(s: string): int =
  let (wfs, _) = s.parseInput()
  let rt = Rating2(
    x: 1 .. 4000,
    m: 1 .. 4000,
    a: 1 .. 4000,
    s: 1 .. 4000
  )
  result = walk(wfs, "in", rt)

doAssert day19b(example) == 167409079868000
doAssert day19b(readFile("./input")) == 135506683246673

echo "ok"
