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

#pagebreak()


#quantum-circuit(
  1, meter(fill: yellow), meter(fill: yellow)[$P_1$ #meter-symbol], meter(n: 2, fill: yellow)[#meter-symbol \ $P$], meter(n: 2), [\ ],
  1, meter[#place(super(baseline: -0.4em)[X]) #meter-symbol]
)

#pagebreak()

// meter with multiple labels

#quantum-circuit(
  meter(label: (content: [A], pos: bottom)),
  meter(
    label: (
      (content: [A], pos: bottom),
      (content: [B]),
    )
  ),
)
