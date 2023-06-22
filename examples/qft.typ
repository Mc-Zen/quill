#import "../quantum-circuit.typ": *

#quantum-circuit(
  scale-factor: 85%,
  row-spacing: 5pt,
  column-spacing: 8pt,
  lstick($|j_1〉$), gate($H$), controlled($R_2$, 1), midstick($ dots $), 
    controlled($R_(n-1)$, 3), controlled($R_n$, 4), 8, rstick($|0〉+e^(2pi i 0.j_1 dots j_n)|1〉$),[\ ],
  lstick($|j_2〉$), 1, ctrl(0), midstick($ dots $), 2, gate($H$), midstick($ dots $), 
    controlled($R_(n-2)$, 2), controlled($R_(n-1)$, 3), midstick($ dots $), 3, 
    rstick($|0〉+e^(2pi i 0.j_2 dots j_n)|1〉$), [\ ],
  
  setwire(0),  midstick($dots.v$), 1, midstick($dots.v$), [\ ],
  
  lstick($|j_(n-1)〉$), 3, ctrl(0), 3, ctrl(0), 1, midstick($ dots $), gate($H$), controlled($R_(2)$, 1), 
    1, rstick($|0〉+e^(2pi i 0.j_(n-1)j_n)|1〉$), [\ ],
  lstick($|j_n〉$), 4, ctrl(0), 3, ctrl(0), midstick($ dots $), 1, ctrl(0), gate($H$), 
    rstick($|0〉+e^(2pi i 0.j_n)|1〉$)
)