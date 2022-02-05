import macros
import imkivy

widget WidgetsBasic:
  object:
    show_demo: bool
    somefloat: float32
    counter: int

  # Simple window
  Window("Widgets"):
    CollapsingHeader("Widgets"):

      Text: "This is some useful text."
      Checkbox("Demo Window", self.show_demo)
      Slider("float", self.somefloat)

      Horizontal:
        Button("Button"):
          size: (w: 50, h: 20)
          on_press: self.counter.inc
        Button("Button"):
          size: (w: 0, h: 0)
          on_press: self.counter.inc
        Text("counter = %d", self.counter)

      Text("Application average %.3f ms/frame (%.1f FPS)",
          1000.0f / igGetIO().framerate, igGetIO().framerate)

