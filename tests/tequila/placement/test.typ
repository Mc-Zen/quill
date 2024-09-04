#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ"
#import quill: tequila as tq

#quill.quantum-circuit(
  1, $X$, $Y$, quill.gate("R", x: 1, y: 1),
  ..tq.build(
    x: 2, y: 1,
    tq.h(0),
    tq.cx(0, 1),
  )
)

#pagebreak()


#quill.quantum-circuit(
  quill.lstick($|0〉$, n: 3),
  ..tq.graph-state(
    y: 1,
    (0, 1)
  ),
  ..tq.build(
    x: 2, y: 3, n: 3,
    tq.h(0),
    tq.cx(0, 1),
  ),
  ..tq.build(
    y: 4,
    tq.y(0), tq.swap(0, 1),
  )
)

#pagebreak()


#quill.quantum-circuit(
  ..tq.build(
    x: 0, y: 0, append-wire: false,
    tq.h(0),
    tq.cx(0, 1),
  )
)
