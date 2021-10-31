import pararules
from pararules/engine import Session, Vars
import json

type
  Id = enum
    Editor, Errors, Tutorial, Publish,
  Attr = enum
    CursorX, CursorY,
    ScrollX, ScrollY,

schema Fact(Id, Attr):
  CursorX: int
  CursorY: int
  ScrollX: int
  ScrollY: int

type
  EditorSession* = Session[Fact, Vars[Fact]]

let rules =
  ruleset:
    rule getEditor(Fact):
      what:
        (Editor, CursorX, cursorX)
        (Editor, CursorY, cursorY)
        (Editor, ScrollX, cursorX)
        (Editor, ScrollY, cursorY)

proc init*(): EditorSession =
  result = initSession(Fact, autoFire = false)
  for r in rules.fields:
    result.add(r)
  result.insert(Editor, CursorX, 0)
  result.insert(Editor, CursorY, 0)
  result.insert(Editor, ScrollX, 0)
  result.insert(Editor, ScrollY, 0)

proc toJson*(session: EditorSession): JsonNode =
  let editor = session.query(rules.getEditor)
  %*{
    "type": "rect",
    "children": [""],
    "children-after": [
      {"type": "cursor", "x": editor.cursorX, "y": editor.cursorY},
    ],
    "top-left": "Write a post",
    "top-left-focused": "Write a post (press Enter to send, or Esc to use the full editor)",
  }
