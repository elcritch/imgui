import macros
import imkivy

widget WidgetsBasic:
  object:
    counter: uint
    check: bool
    radio: int32
    radio2: int32

  # Simple window
  Window("Widgets"):
    CollapsingHeader("Basic"):

      Horizontal:
        Button("Button"):
          on_press: self.counter.inc()
        ShowWhen((self.counter mod 2) == 1):
          Text("Thanks for clicking me! ")

      Checkbox("checkbox", self.check)

      Horizontal:
        RadioButton("radio a", self.radio, 0)
        RadioButton("radio b", self.radio, 1)
        RadioButton("radio c", self.radio, 2)

      RadioButtons(self.radio2, horiz=true):
        ("radio a", 0)
        ("radio b", 1)
        ("radio c", 2)

      Text("radio: %d", self.radio2)

