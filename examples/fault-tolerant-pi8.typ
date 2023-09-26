#import "../src/quill.typ": *

#let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

#quantum-circuit(
  group(1, 4, padding: (left: 1.5em)), lstick($|0〉$), nwire(""), $H$, $T$, 
    ctrl(1), $S X$, rstick($T|ψ〉$), [\ ],
  lstick($|ψ〉$), nwire(""), 2, targ(), meter(target: -1), 
)