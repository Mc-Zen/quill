#import "../quantum-circuit.typ": *

#quantum-circuit(
  lstick($|psi〉$),  ctrl(1), gate($H$), 1, ctrl(0), meter(), [\ ],
  lstick($|beta_00〉$, n: 2), targ(), 1, ctrl(0), 1, meter(), [\ ],
  3, controlled($X$, -1), controlled($Z$, -2),  midstick($|psi〉$)
)

