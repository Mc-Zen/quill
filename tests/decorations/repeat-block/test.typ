#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  1, repeat-block(2, label: $n$), $H$, $X$, 1
)

#pagebreak()

#quantum-circuit(
  1, repeat-block(2, brace: "(", fill: green, z: "below", label: ((pos: top, content: "2 times"), (pos: top + left, content: "B")),), $H$, $X$, 1
)

#pagebreak()
#quantum-circuit(
  1, repeat-block(brace: "||:", 2, wires: 1, y: 1, fill: red),ctrl(1), 2,  [\ ],
  1, gate($X$), gate($Z$), 
)