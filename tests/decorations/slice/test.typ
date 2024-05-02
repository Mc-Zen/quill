#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  ctrl(0), slice(), 1, [\ ],
  slice(), slice(x: 4, y: 0, n: 1, stroke: blue)
)