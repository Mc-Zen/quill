#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, mqgate(n: 3, fill: none)[E], 1, [\ ], [\ ]
)

#pagebreak()

#quantum-circuit(
  [\ ],
  1, mqgate(n: 4, fill: none, pass-through: (2,))[E], 1, [\ ], [\ ], [\ ]
)