#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, $H$, [\ ],
  1, $H$, [\ ],
  1, $H$, [\ ],
  ..range(3).map(i => mqgate($+$, x: i + 2, y: i, n: 2)),
  ..range(3).map(i => meter(x: 6, y: i)),
  ..range(3).map(i => ctrl(x: 7, y: i)),
  ..range(3).map(i => lstick($|0〉$, x: 0, y: i)),
  gategroup(4, 3, x: 2, y: 0),
  slice(y: 1, x: 6, n: 2),
)

#pagebreak()

#quantum-circuit(
  gate($H$, y: 1), gate($H$, y: 0), 1, $B$, gate($X$, x: 4), [\ ], gate($X$, x:3)
)

#pagebreak()

#quantum-circuit(
  gate($H$, x: 2), gate($H$, x: 1), $B$, 2, $N$
)

#pagebreak()

#quantum-circuit(
  $X$, 20pt, $Y$, slice(y: 0, n: 1), 20pt, $Y$,  20pt, $ß$,  20pt, gategroup(x: 0, y: 0, 1, 4), mqgate("a", n: 1)
)