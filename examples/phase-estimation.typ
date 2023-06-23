#import "../quantum-circuit.typ": *

#quantum-circuit(
  setwire(0), lstick(align(center)[First register\ $t$ qubits], n: 4), lstick($|0〉$), 
    setwire(1), gate($H$), 4, midstick($ dots $), ctrl(4), rstick($|0〉$), [\ ], 10pt,
  setwire(0), phantom(width: 13pt), lstick($|0〉$), setwire(1), gate($H$), 2, ctrl(3), 1, 
    midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), gate($H$), 1, ctrl(2), 2, 
    midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), gate($H$), ctrl(1), 3, midstick($ dots $), 1, 
    rstick($|0〉$), [\ ],
  setwire(0), lstick([Second register], n: 1, brace: "{"), lstick($|u〉$), 
    setwire(4, wire-distance: 1.3pt), 1, gate($ U^2^0 $), gate($ U^2^1 $), gate($ U^2^2 $), 
    1, midstick($ dots $), gate($ U^2^(t-1) $), rstick($|u〉$)
)