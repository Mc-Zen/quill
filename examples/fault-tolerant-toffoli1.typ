#import "../quill.typ": *

#quantum-circuit(
  lstick($|0〉$), gate($H$), ctrl(3), 5, gate($X$), ctrl(2), rstick($|x〉$), [\ ],
  lstick($|0〉$), gate($H$), 1, ctrl(3), 3, gate($X$), 1, ctrl(0), rstick($|y〉$), [\ ],
  lstick($|0〉$), 3, targ(), 1, gate($Z$), 2, targ(), rstick($|z plus.circle x y〉$), [\ ],
  lstick($|x〉$), 1, targ(), 5, meter(target: -3), [\ ],
  lstick($|y〉$), 2, targ(), 3, meter(target: -3), [\ ],
  lstick($|z〉$), 3, ctrl(-3), gate($H$), meter(target: -3)
)