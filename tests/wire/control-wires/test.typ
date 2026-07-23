#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(circuit-padding: 0pt,
  mqgate($a$, target: 1, wire-count: 1, wire-label: (content: "a", dx: 0pt)),
  ctrl(1, wire-count: 2, wire-label: (content: "a", dx: 0pt)),
  swap(1, wire-count: 3, wire-label: (content: "a", dx: 0pt)),
  mqgate($a$, target: 1, wire-count: 4, wire-label: (content: "a", dx: 0pt)), 
  mqgate($a$, target: 1, wire-count: 5, wire-label: (content: "abcde", dx: 0pt)),[\ ],
  mqgate($a$, target: 1, wire-count: 1),
  ctrl(1, wire-count: 2),
  swap(1, wire-count: 3),
  mqgate($a$, target: 1, wire-count: 4), 
  mqgate($a$, target: 1, wire-count: 5),[\ ], 
  5
)

#pagebreak()


#quantum-circuit(
  wire: 1pt,
  fill-wires: false, 
  mqgate(target: 1, wire-stroke: red)[A], 1, swap(1, wire-stroke: 2pt), targ(1, wire-stroke: blue + .5pt), [\ ],
  1, ctrl(-1, wire-stroke: (dash: "dashed")), 2, meter(target: -1, wire-stroke: silver), 
)