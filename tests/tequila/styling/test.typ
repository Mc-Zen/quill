#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ"
#import quill: tequila as tq

#quill.quantum-circuit(
  ..tq.build(
    tq.h(0),
    tq.cx(0, 1, open: true, wire-label: sym.dots.v),
    tq.ccx(0, 2, 1, open: true),
    tq.multi-controlled-gate((0, 1), 2, quill.targ, open: true),
  )
)

#pagebreak()