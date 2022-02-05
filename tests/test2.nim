# Copyright 2019, NimGL contributors.

import imgui, imgui/[impl_opengl, impl_glfw]
import nimgl/[opengl, glfw]

import imkivy
import example_window
import demo_window

import std/os, std/times, std/monotimes

var ft = getMonoTime().ticks().toBiggestFloat() * 1.0e-9

proc main() =
  assert glfwInit()

  glfwWindowHint(GLFWContextVersionMajor, 4)
  glfwWindowHint(GLFWContextVersionMinor, 1)
  glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE)
  glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFWResizable, GLFW_FALSE)

  var w: GLFWWindow = glfwCreateWindow(1280, 720)
  if w == nil:
    quit(-1)

  w.makeContextCurrent()

  assert glInit()

  let context = igCreateContext()
  #let io = igGetIO()

  assert igGlfwInitForOpenGL(w, true)
  assert igOpenGL3Init()

  igStyleColorsCherry()

  var style = igGetStyle()
  style.framePadding = ImVec2(x: 5, y: 5) 
  style.cellPadding = ImVec2(x: 7, y: 4) 
  style.itemSpacing = ImVec2(x: 11, y: 5) 
  style.itemInnerSpacing = ImVec2(x: 7, y: 2) 
  style.scrollbarSize = 24.0
  style.grabMinSize = 24.0

  var show_demo: bool = true
  var somefloat: float32 = 0.0f
  var counter: int32 = 0
  
  var exData = ExampleWindowData()
  var demoData = WidgetsBasicData()

  while not w.windowShouldClose:
    glfwPollEvents()

    igOpenGL3NewFrame()
    igGlfwNewFrame()
    igNewFrame()

    if show_demo:
      igShowDemoWindow(show_demo.addr)

    Window("Hello, world!"):
      ExampleWindow(exData)
      WidgetsBasic(demoData)
      Button("Button"):
        size: (50, 20)
        on_press: 
          echo "demoData: ", repr(demoData)

    igRender()

    glClearColor(0.45f, 0.55f, 0.60f, 1.00f)
    glClear(GL_COLOR_BUFFER_BIT)

    igOpenGL3RenderDrawData(igGetDrawData())

    w.swapBuffers()
    var ct = getMonoTime().ticks().toBiggestFloat() * 1.0e-9
    var dt = 1.0/65.0 - (ct - ft)
    os.sleep(toInt(1000*dt))

    ft = getMonoTime().ticks().toBiggestFloat() * 1.0e-9

  igOpenGL3Shutdown()
  igGlfwShutdown()
  context.igDestroyContext()

  w.destroyWindow()
  glfwTerminate()

main()
