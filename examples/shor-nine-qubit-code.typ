#import "../quill.typ": *

#let ancillas = (setwire(0), 5, lstick($|0〉$), setwire(1), targ(), 2, [\ ],
setwire(0), 5, lstick($|0〉$), setwire(1), 1, targ(), 1, [\ ])

#quantum-circuit(
  scale-factor: 80%,
  lstick($|ψ〉$), 1, 10pt, ctrl(3), ctrl(6), gate($H$), 1, 15pt, 
    ctrl(1), ctrl(2), 1, [\ ],
  ..ancillas,
  lstick($|0〉$), 1, targ(), 1, gate($H$), 1, ctrl(1), ctrl(2), 
    1, [\ ],
  ..ancillas,
  lstick($|0〉$), 2, targ(),  gate($H$), 1, ctrl(1), ctrl(2), 
    1, [\ ],
  ..ancillas
)