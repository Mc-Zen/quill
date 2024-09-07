#import "../src/quill.typ": *

#import tequila as tq

#quantum-circuit(
  ..tq.graph-state((0, 1), (1,2)),
  ..tq.build(y: 3, 
      tq.p($pi$, 0), 
      tq.cx(0, (1, 2)), 
    ),
  ..tq.graph-state(x: 6, y: 2, invert: true, (0, 1), (0, 2)),
  gategroup(x: 1, 3, 3),
  gategroup(x: 1, y: 3, 3, 3),
  gategroup(x: 6, y: 2, 3, 3),
  slice(x: 5)
)