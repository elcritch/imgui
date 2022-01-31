import macros
import imkivy

widget WidgetsBasic:
  # Simple window
  Window("Widgets"):
    CollapsingHeader("Widgets"):

      Text: "This is some useful text."
      Checkbox("Demo Window", show_demo)
      Slider("float", somefloat)

      Horizontal:
        Button("Button"):
          size: (w: 50, h: 20)
          on_press: counter.inc
        Button("Button"):
          size: (w: 0, h: 0)
          on_press: counter.inc
        Text("counter = %d", counter)

      Text("Application average %.3f ms/frame (%.1f FPS)",
          1000.0f / igGetIO().framerate, igGetIO().framerate)

