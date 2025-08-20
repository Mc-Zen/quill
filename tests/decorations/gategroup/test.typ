#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  gategroup(1, 2, label: ((pos: top, content: "A"), (pos: left, content: "B")),), $K$, 1, 5pt, swap(), [\ ],
  2, swap(-1), 
  gategroup(2, 1, x: 2, y: 0, label: "swap", stroke: .5pt + blue, radius: 4pt, fill: blue)
)

#pagebreak()


#quantum-circuit(
  gategroup(1, -1), $X$, $Y$, $p$, [\ ],
  gategroup(-1, -2), $X$, $Y$, $p$, [\ ],
  [\ ],
  gategroup(x: 2, y: 1, -2, 1)
)