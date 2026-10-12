#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(wire: red, 1, $H$, 1, ctrl(1), 1, [\ ], 1)

#pagebreak()

#quantum-circuit(wire: 1.5pt + blue, setwire(2), 3, meter(), 1)
