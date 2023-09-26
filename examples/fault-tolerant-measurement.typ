#import "../src/quill.typ": *

#let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

#quantum-circuit(
  row-spacing: 6pt,
  lstick($|0〉$), 10pt, group(3, 2, label: (content: "Prepare")), $H$, ctrl(2), 3pt, 
    group(4, 2, label: (content: "Verify")), 3,
    group(7, 3, label: (content: [Controlled-$M$])),
    ctrl(4), 2, 10pt, group(3, 2, label: (content: "Decode")), ctrl(2), $H$, meter(), [\ ],  
  lstick($|0〉$), 1, targ(), 1, ctrl(2), 2, ctrl(4), 1, targ(), 2, [\ ], 
  lstick($|0〉$), 1, targ(), ctrl(1), 4, ctrl(4), targ(), 2, [\ ],  
  setwire(0), 2, lstick($|0〉$), setwire(1), targ(), targ(), 1, [\ ], 10pt,
  setwire(0), 4, lstick(align(center)[Encoded\ Data], n: 3), setwire(1), 1,
    $M'$, 3, [\ ],
  setwire(0), 5,  setwire(1), 2, $M'$, 2, [\ ],
  setwire(0), 5,  setwire(1), 3, $M'$, 1,
)