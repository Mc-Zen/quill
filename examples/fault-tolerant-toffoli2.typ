  #import "../src/quill.typ": *

  #let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

  #quantum-circuit(
    fill-wires: false,
    group(3, 3, padding: (left: 1.5em)), lstick($|0〉$), $H$, ctrl(2), ctrl(3), 3,
      group(2, 1),ctrl(1), 1, group(3, 1), ctrl(2), $X$, 1, rstick($|x〉$), [\ ],
    lstick($|0〉$), $H$, ctrl(0), 1, ctrl(3), 2, $Z$, $X$, 2, group(2, 1),
      ctrl(1), rstick($|y〉$), [\ ],
    lstick($|0〉$), 1, targ(), 2, targ(), 1, mqgate($Z$, target: -1, wire-count: 2), 1, 
      targ(fill: auto), 1, targ(fill: auto), rstick($|z plus.circle x y〉$), [\ ],
    lstick($|x〉$), 2, targ(), 6, meter(target: -3), setwire(2), ctrl(-1, wire-count: 2), [\ ],
    lstick($|y〉$), 3, targ(), 3, meter(target: -3), setwire(2), ctrl(-2, wire-count: 2), [\ ],
    lstick($|z〉$), 4, ctrl(-3), $H$, meter(target: -3)
  )