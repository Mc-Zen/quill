#import "../quill.typ": *

#let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

#quantum-circuit(
  group(1, 4, padding: (left: 1.5em)), lstick($|0〉$), nwire(""), gate($H$), gate($T$), 
    ctrl(1), gate($S X$), rstick($T|ψ〉$), [\ ],
  lstick($|ψ〉$), nwire(""), 2, targ(), meter(target: -1), 
)