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