#import "../quill.typ": *

#let mark(text, col1, col2) = annotate(0, (col1, col2), 
  (y, (x1, x2)) => style(styles => {
    let size = measure(text, styles)
    place(dx: x1 + (x2 - x1)/2 - size.width/2, dy: y - .6em - size.height, text)
  })
)
#let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))

#quantum-circuit(
  row-spacing: 6pt,
  circuit-padding: (top: 2em),
  lstick($|0〉$), 10pt, group(3, 2), gate($H$), ctrl(2), 3pt, group(4, 2), 3, group(7, 3), 
    ctrl(4), 2, 10pt, group(3, 2), ctrl(2), gate($H$), meter(), [\ ],  
  lstick($|0〉$), 1, targ(), 1, ctrl(2), 2, ctrl(4), 1, targ(), 2, [\ ], 
  lstick($|0〉$), 1, targ(), ctrl(1), 4, ctrl(4), targ(), 2, [\ ],  
  setwire(0), 2, lstick($|0〉$), setwire(1), targ(), targ(), 1, [\ ], 10pt,
  setwire(0), 4, lstick(align(center)[Encoded\ Data], n: 3), setwire(1), 1, 
    gate($M'$), 3, [\ ],
  setwire(0), 5,  setwire(1), 2, gate($M'$), 2, [\ ],
  setwire(0), 5,  setwire(1), 3, gate($M'$), 1,
  mark("Prepare", 1, 3),
  mark("Verify", 3, 5),
  mark([Controlled-$M$], 5, 9),
  mark("Decode", 9, 11)
)