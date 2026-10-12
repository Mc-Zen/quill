#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, phantom(content: $X$), 1, $H$, 1
)

#pagebreak()

#quantum-circuit(
  1, phantom(width: 20pt, height: 15pt), $H$, 1, [\ ],
  1, phantom(width: 12pt, height: 8pt), $Y$, 1
)
