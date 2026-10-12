#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  circuit-padding: 10pt,
  lstick($|psi〉$), 1, $H$, 1, rstick($|psi〉$)
)

#pagebreak()

#quantum-circuit(
  circuit-padding: (left: 15pt, top: 8pt),
  gate($H$, label: "top"), 1
)
