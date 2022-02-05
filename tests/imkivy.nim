import macros
import sugar

import imgui, imgui/[impl_opengl, impl_glfw]
import nimgl/[opengl, glfw]

export imgui, impl_opengl, impl_glfw
export opengl, glfw
export sugar

template Window*(title: string, blk: untyped) =
  ## window blk
  igBegin(title)
  blk
  igEnd()

macro Text*(args: varargs[untyped]) =
  result = quote do:
    igText(`args`)

template Checkbox*(label: string, val: var bool) =
  igCheckbox(label, val.addr)

template Slider*(label: string, val: var float, min = 0.0, max = 1.0) =
  igSliderFloat(label, val.addr, min, max)

var btncnt {.compileTime.} = 0

macro Button*(label: string, blk: untyped) =
  # echo "button: blk: ", blk.treeRepr
  var onPressAct: NimNode
  var sizeProp: NimNode

  for code in blk:
    if code.kind == nnkCall:
      var name = code[0]
      case name.repr:
      of "on_press":
        onPressAct = code[1]
      of "size":
        let val = code[1]
        sizeProp = quote do:
          let sz = `val`
          ImVec2(x: sz[0].toFloat(), y: sz[1].toFloat())

  btncnt.inc()
  var btnid = btncnt 
  if sizeProp.isNil:
    result = quote do:
      igPushID(`btnid`)
      if igButton(`label`):
        `onPressAct`
      igPopId()
  else:
    result = quote do:
      igPushID(`btnid`)
      if igButton(`label`, `sizeProp`):
        `onPressAct`
      igPopId()

template Slider*(label: string, val: var float, min = 0.0, max = 1.0) =
  igSliderFloat(label, val.addr, min, max)

macro Horizontal*(blk: untyped) =
  result = newStmtList()
  for idx, child in blk.pairs():
    result.add child
    if idx + 1 < blk.len():
      result.add quote do:
        igSameLine()
  # result.add quote do: igNewLine()

macro widget*(class: untyped, blk: untyped) =
  var objectFields: NimNode
  var body = newStmtList()
  for code in blk:
    # echo "widget:code: ", code.treeRepr
    if code.kind == nnkCall:
      var name = code[0]
      case name.repr:
      of "object":
        objectFields = code[1]
        # echo "widget:code:defs: ", objectFields.treeRepr
        continue
    body.add code

  var objName = newIdentNode class.repr & "Data"
  var objectDef = quote do:
    type `objName`* = ref object
      id: int
  
  var elems = newSeq[NimNode]()
  for field in objectFields:
    var name = field[0].repr
    var kind = field[1][0].repr
    elems.add nnkIdentDefs.newTree(
      newIdentNode(name),
      newIdentNode(kind),
      newEmptyNode()
    )
  # Change up the `RecList` child
  objectDef[0][^1][0][^1].add(elems)

  var self = newIdentNode "self"
  result = newStmtList()
  result.add objectDef
  result.add quote do:
    proc `class`*(`self`: var `objName`) =
      `body`
  # echo "result:\n", result.treeRepr

template CollapsingHeader*(label: string, blk: untyped): untyped =
  if igCollapsingHeader(label, 0.ImGuiTreeNodeFlags):
    blk
template CollapsingHeader*(label: string, flags: ImGuiTreeNodeFlags, blk: untyped): untyped =
  if igCollapsingHeader(label, flags):
    blk
