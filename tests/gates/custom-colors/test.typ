#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  // setwire(2),
  gate($X$, fill: gray), phase($text(a, fill: #red)$, fill: red), phase($text(a, fill: #red)$, stroke: .7pt + red, open: true), gate($F_m$, radius: 100%), gate($F#h(.2em)$, radius: (right: 100%), fill: green), targ(fill: auto), targ(fill: blue), ctrl(fill: blue), ctrl(stroke: .7pt + blue, open: true), ctrl(fill: blue),  ctrl(stroke: .7pt + blue, open: true), 1
)

#pagebreak()

#quantum-circuit(
  lstick(fill: blue, n: 2)[], swap(0, stroke: 2pt), targ(0, stroke: red), 1, meter(stroke: blue), 
  rstick(fill: blue, n: 2)[], [\ ], 
  1, ctrl(open: true, fill: red, stroke: green),
  phase(open: true, fill: red, stroke: green)[],
)