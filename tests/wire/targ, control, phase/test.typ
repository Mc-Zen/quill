#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  scale: 150%,
  1, targ(), ctrl(0, open: true), phase($α$, open: true), 1, [\ ],
  setwire(2),
  1, targ(fill: true), ctrl(0, open: true), phase($α$, open: true), 1, [\ ],
  setwire(3),
  1, targ(fill: true), ctrl(0, open: true), phase($α$, open: true), 1,
)