#import "../src/quill.typ": *

#quantum-circuit(
  fill-wires: false,
  lstick($|0〉$), $H$, ctrl(3), 5, $X$, ctrl(2), rstick($|x〉$), [\ ],
  lstick($|0〉$), $H$, 1, ctrl(3), 3, $X$, 1, ctrl(), rstick($|y〉$), [\ ],
  lstick($|0〉$), 3, targ(), 1, $Z$, 2, targ(), rstick($|z plus.o x y〉$), [\ ],
  lstick($|x〉$), 1, targ(), 5, meter(target: -3), [\ ],
  lstick($|y〉$), 2, targ(), 3, meter(target: -3), [\ ],
  lstick($|z〉$), 3, ctrl(-3), $H$, meter(target: -3)
)