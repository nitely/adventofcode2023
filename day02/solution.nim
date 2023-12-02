import std/strutils
import std/strscans

proc day2(): int =
  result = 0
  var input = readFile("./input")
  var game = 0
  var gameSets = ""
  while scanf(input, "Game $i: $*\n$*", game, gameSets, input):
    var isOk = true
    var num = 0
    var color = ""
    while scanf(gameSets.strip(chars={' ', ',', ';'}), "$i $w$*", num, color, gameSets):
      let isColorOk = case color:
        of "red": num <= 12
        of "green": num <= 13
        of "blue": num <= 14
        else: doAssert false; false
      isOk = isOk and isColorOk
    doAssert gameSets.len == 0
    if isOk:
      result += game
  doAssert input.len == 0

echo day2()

proc day2b(): int =
  result = 0
  var input = readFile("./input")
  var game = 0
  var gameSets = ""
  while scanf(input, "Game $i: $*\n$*", game, gameSets, input):
    var
      red = 0
      green = 0
      blue = 0
    var num = 0
    var color = ""
    while scanf(gameSets.strip(chars={' ', ',', ';'}), "$i $w$*", num, color, gameSets):
      case color:
        of "red": red = max(red, num)
        of "green": green = max(green, num)
        of "blue": blue = max(blue, num)
        else: doAssert false
    doAssert gameSets.len == 0
    result += red * green * blue
  doAssert input.len == 0

echo day2b()
