#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  gate($X$, fill: gray), phase($text(a, fill: #red)$, fill: red), phase($text(a, fill: #red)$, fill: .7pt + red, open: true), gate($F_m$, radius: 100%), gate($F#h(.2em)$, radius: (right: 100%), fill: green), targ(fill: auto), targ(fill: blue), ctrl(fill: blue), ctrl(fill: .7pt + blue, open: true), ctrl(fill: blue),  ctrl(fill: .7pt + blue, open: true), 1
)