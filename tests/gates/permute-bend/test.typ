#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, permute(2, 0, 1), 1, [\ ],
  1, 1, [\ ],
  1, 1
)

#pagebreak()

#quantum-circuit(
  1, permute(2, 0, 1, bend: 0%), 1, [\ ],
  1, 1, [\ ],
  1, 1
)

#pagebreak()

#quantum-circuit(
  1, permute(1, 2, 0, wire-count: (1, 2, 1)), 1, [\ ],
  1, 1, [\ ],
  1, 1
)
