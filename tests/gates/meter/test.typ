#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, meter(n: 3), [\ ], 2, [\ ], 2
)

#pagebreak()

#quantum-circuit(
  scale: 120%,
  1, meter(label: $y$), 1, meter(n: 1, label: $lr(|plus.minus〉)$), meter(label: $phi/2$, n: 1, wire-count: 1), meter(target: 1, label: $X$), meter(n: 2, label: $X$), [\ ],
  1, meter(radius: 3pt, fill: gray), 3,ctrl(), 1
)

#pagebreak()

#quantum-circuit(
  gate-padding: 2pt,
  wire: .2pt + red,
  color: red,
  1, meter(label: $y$), 1, meter(n: 1, label: $lr(|plus.minus〉)$), meter(label: $phi/2$, n: 1, wire-count: 1), meter(target: 1, label: "a"), meter(n: 2, label: "a"), [\ ],
  1, gate($H$), 3, ctrl(), 2
)