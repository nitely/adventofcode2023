import std/strutils
import std/strscans

proc day2(): int =
  result = 0
  let input = readFile("./input")
  for line in input.splitLines:
    if line.len == 0: continue
    var game = 0
    var rest = ""
    let m = scanf(line, "Game $i: $*", game, rest)
    doAssert m
    var isOk = true
    var num = 0
    var color = ""
    while scanf(rest.strip(chars={' ', ',', ';'}), "$i $w$*", num, color, rest):
      let isColorOk = case color:
        of "red": num <= 12
        of "green": num <= 13
        of "blue": num <= 14
        else: doAssert false; false
      isOk = isOk and isColorOk
    doAssert rest.len == 0
    if isOk:
      result += game

echo day2()

proc day2b(): int =
  result = 0
  let input = readFile("./input")
  for line in input.splitLines:
    if line.len == 0: continue
    var game = 0
    var rest = ""
    let m = scanf(line, "Game $i: $*", game, rest)
    doAssert m
    var
      red = 0
      green = 0
      blue = 0
    var num = 0
    var color = ""
    while scanf(rest.strip(chars={' ', ',', ';'}), "$i $w$*", num, color, rest):
      case color:
        of "red": red = max(red, num)
        of "green": green = max(green, num)
        of "blue": blue = max(blue, num)
        else: doAssert false
    doAssert rest.len == 0
    result += red * green * blue

echo day2b()
