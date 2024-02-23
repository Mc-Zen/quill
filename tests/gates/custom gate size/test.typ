#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  targ(), targ(size: 6pt), targ(size: 3pt), ctrl(0), ctrl(0, size: 4pt), ctrl(0, open: true), ctrl(0, size: 4pt, open: true), ctrl(0), ctrl(0, size: 4pt)
)

#pagebreak()

#quantum-circuit(scale-factor: 70%,
  targ(), targ(size: 6pt), targ(size: 3pt), ctrl(0), ctrl(0, size: 4pt), ctrl(0, open: true), ctrl(0, size: 4pt, open: true), ctrl(0), ctrl(0, size: 4pt)
)