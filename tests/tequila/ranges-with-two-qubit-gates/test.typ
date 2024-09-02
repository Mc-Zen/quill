#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ"
#import quill: tequila as tq

#quill.quantum-circuit(
  ..tq.build(
    tq.cx((0, 1), (1, 2)),
    tq.cx(0, (1,2)),
    tq.cx((1, 2), 0),
  )
)
