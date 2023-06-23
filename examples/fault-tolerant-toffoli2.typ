#import "../quantum-circuit.typ": *

#let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

#quantum-circuit(
  group(3, 3, padding: (left: 1.5em)), lstick($|0〉$), gate($H$), ctrl(2), ctrl(3), 3, 
    group(2, 1),ctrl(1), 1, group(3, 1), ctrl(2), gate($X$), 1, rstick($|x〉$), [\ ],
  lstick($|0〉$), gate($H$), ctrl(0), 1, ctrl(3), 2, gate($Z$), gate($X$), 2, group(2, 1),
    ctrl(1), rstick($|y〉$), [\ ],
  lstick($|0〉$), 1, targ(), 2, targ(), 1, gate($Z$), 1, targ(fill: true), 1, targ(fill: true), 
    rstick($|z plus.circle x y〉$), [\ ],
  lstick($|x〉$), 2, targ(), 6, meter(n: -3), setwire(2), ctrl(-1, wire-count: 2), [\ ],
  lstick($|y〉$), 3, targ(), 3, meter(n: -3), setwire(2), ctrl(-2, wire-count: 2), [\ ],
  lstick($|z〉$), 4, ctrl(-3), gate($H$), meter(n: -4)
)