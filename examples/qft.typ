#import "../src/quill.typ": *

#quantum-circuit(
  scale: 85%,
  row-spacing: 5pt,
  column-spacing: 8pt,
  lstick($|j_1〉$), gate($H$), gate($R_2$), midstick($ dots $), 
    gate($R_(n-1)$), gate($R_n$), 8, 
    rstick($|0〉+e^(2pi i 0.j_1 dots j_n)|1〉$),[\ ],
  lstick($|j_2〉$), 1, ctrl(-1), midstick($ dots $), 2, gate($H$), midstick($ dots $), 
    gate($R_(n-2)$), gate($R_(n-1)$), midstick($ dots $), 3, 
    rstick($|0〉+e^(2pi i 0.j_2 dots j_n)|1〉$), [\ ],
  
  setwire(0),  midstick($dots.v$), 1, midstick($dots.v$), [\ ],
  
  lstick($|j_(n-1)〉$), 3, ctrl(-3), 3, ctrl(-2), 1, midstick($ dots $), gate($H$), 
    gate($R_2$), 1, rstick($|0〉+e^(2pi i 0.j_(n-1)j_n)|1〉$), [\ ],
  lstick($|j_n〉$), 4, ctrl(-4), 3, ctrl(-3), midstick($ dots $), 1, ctrl(-1), gate($H$), 
    rstick($|0〉+e^(2pi i 0.j_n)|1〉$)
)