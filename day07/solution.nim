import std/strutils
import std/sequtils
import std/algorithm

const example = """

"""

const cmpMap = [
  'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'
]

type Hand = object
  cards: string
  bid: int

func toHand(s: string): Hand =
  let parts = s.split(' ')
  result = Hand(
    cards: parts[0],
    bid: parseInt parts[1]
  )

func strength(cards: string): int =
  template allEq(s:untyped): untyped =
    s.allIt(it == s[0])
  doAssert cards.allIt(it in cmpMap)
  var c = cards
  c.sort(proc (a,b: char): int = cmp(cmpMap.find(a), cmpMap.find(b)))
  # Five of a kind
  if [c[0], c[1], c[2], c[3], c[4]].allEq:
    result = 1
  # Four of a kind
  elif [c[0], c[1], c[2], c[3]].allEq or [c[1], c[2], c[3], c[4]].allEq:
    result = 2
  # Full house
  elif ([c[0], c[1], c[2]].allEq and [c[3], c[4]].allEq) or
      ([c[0], c[1]].allEq and [c[2], c[3], c[4]].allEq):
    result = 3
  # Three of a kind
  elif [c[0], c[1], c[2]].allEq or
      [c[1], c[2], c[3]].allEq or
      [c[2], c[3], c[4]].allEq:
    result = 4
  # Two pair
  elif ([c[0], c[1]].allEq and [c[2], c[3]].allEq) or
      ([c[1], c[2]].allEq and [c[3], c[4]].allEq) or
      ([c[0], c[1]].allEq and [c[3], c[4]].allEq):
    result = 5
  # One pair
  elif [c[0], c[1]].allEq or
      [c[1], c[2]].allEq or
      [c[2], c[3]].allEq or
      [c[3], c[4]].allEq:
    result = 6
  else:
    result = 7

func cmpCardByCard(a,b: Hand, map = cmpMap): int =
  for i in 0 .. 4:
    result = cmp(map.find(a.cards[i]), map.find(b.cards[i]))
    if result != 0:
      break
  doAssert result != 0

func cmpHands(a,b: Hand): int =
  result = cmp(a.cards.strength, b.cards.strength)
  if result == 0:
    result = cmpCardByCard(a, b, cmpMap)

func parseInput(s: string): seq[Hand] =
  result = s
    .splitLines()
    .filterIt(it.len > 0)
    .mapIt(it.toHand())

func day7(s: string): int =
  var hands = s.parseInput()
  hands.sort(cmpHands)
  #debugEcho hands
  result = 0
  for i, h in pairs hands:
    result += h.bid * (hands.len-i)

proc day7FromFile(): int =
  var input = readFile("./input")
  result = input.day7()

doAssert day7(example) == 6440
doAssert day7FromFile() == 241344943

const cmpMap2 = [
  'A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'
]

func strongest(cards: string): int =
  result = int.high
  for c in cmpMap:
    if c == 'J': continue
    result = min(result, cards.replace('J', c).strength)
  doAssert result != int.high

func cmpHands2(a,b: Hand): int =
  result = cmp(a.cards.strongest, b.cards.strongest)
  if result == 0:
    result = cmpCardByCard(a, b, cmpMap2)

func day7b(s: string): int =
  var hands = s.parseInput()
  hands.sort(cmpHands2)
  #debugEcho hands
  result = 0
  for i, h in pairs hands:
    result += h.bid * (hands.len-i)

proc day7bFromFile(): int =
  var input = readFile("./input")
  result = input.day7b()

doAssert day7b(example) == 5905
doAssert day7bFromFile() == 243101568

echo "ok"
