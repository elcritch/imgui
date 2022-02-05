import macros
import imkivy

widget WidgetsBasic:
  object:
    counter: uint
    check: bool

  # Simple window
  Window("Widgets"):
    CollapsingHeader("Basic"):

      Horizontal:
        Button("Button"):
          on_press: self.counter.inc()

        if (self.counter mod 2) == 1:
          Text("Thanks for clicking me! ")
        else:
          Text("")

      Checkbox("checkbox", self.check)
