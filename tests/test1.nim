import unittest
import ansiwave
import strutils

import ansiwavepkg/ansi
const content = staticRead("luke_and_yoda.ans")
print(ansiToUtf8(content))

test "Dedupe codes":
  const text = "\e[31m\e[32m\e[41;42;43mHello, world!\e[31m"
  let newText = text.dedupeCodes
  check newText.escape == "\e[32;43mHello, world!\e[31m".escape

import ansiwavepkg/wavescript

test "Parse commands":
  const text = strutils.splitLines(staticRead("hello.ansiwave"))
  let cmds = text.parse
  check cmds.len == 2

test "Parse operators":
  const text = @["/rock-organ c#+3 /octave 3 d-,c /2 1/2 c,d c+"]
  let cmds = text.parse
  check cmds.len == 1
  for cmd in cmds:
    echo cmd.parse
