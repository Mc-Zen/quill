#import "../src/quill.typ": *

#quantum-circuit(
  setwire(0), lstick(align(center)[First register\ $t$ qubits], n: 4, pad: 10.5pt), lstick($|0〉$), 
    setwire(1), $H$, 4, midstick($ dots $), ctrl(4), rstick($|0〉$), [\ ], 10pt,
  setwire(0), phantom(width: 13pt), lstick($|0〉$), setwire(1), $H$, 2, ctrl(3), 1,
    midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), $H$, 1, ctrl(2), 2,
    midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), $H$, ctrl(1), 3, midstick($ dots $), 1,
    rstick($|0〉$), [\ ],
  setwire(0), lstick([Second register], n: 1, brace: "{", pad: 10.5pt), lstick($|u〉$),
    setwire(4, wire-distance: 1.3pt), 1, $ U^2^0 $, $ U^2^1 $, $ U^2^2 $,
    1, midstick($ dots $), $ U^2^(t-1) $, rstick($|u〉$)
)