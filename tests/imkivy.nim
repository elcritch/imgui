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

macro widget*(class: untyped, blk: untyped) =
  # var class = blk[0][0][0]
  # var body = blk[0][1]
  var body = blk
  result = newStmtList()
  result.add quote do:
    template `class`*(): untyped =
      `body`
  # echo "result: ", result.repr

template CollapsingHeader*(label: string, blk: untyped): untyped =
  if igCollapsingHeader(label, 0.ImGuiTreeNodeFlags):
    blk
template CollapsingHeader*(label: string, flags: ImGuiTreeNodeFlags, blk: untyped): untyped =
  if igCollapsingHeader(label, flags):
    blk
