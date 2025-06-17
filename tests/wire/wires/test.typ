#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *



#quantum-circuit(
  wires: (1, 2, 3),
  4, [\ ],
  4, [\ ],
  4, [\ ],
)

#pagebreak()

#quantum-circuit(
  wires: (2, 1, 1, 3),
  2, setwire(1), 1, [\ ],
  setwire(3)
)

#pagebreak()

#quantum-circuit(
  wires: 4,
  2, [\ ],
  2, [\ ],
)

