#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  1, $X$, ctrl(1), 1, [\ ],
  break-line(end: -1), 
  1, $X$, targ(), 1, 
)

#pagebreak()


#quantum-circuit(
  break-line(y: 2), 
  1, $X$, ctrl(1), 1, [\ ],
  1, $X$, ctrl(1), 1, [\ ],
  1, $X$, targ(), 1, 
)


#pagebreak()


#quantum-circuit(
  1, $X$, 1, ctrl(1), 1, [\ ],
  break-line(start: 1, end: 2, stroke: red, wavy: 0%, thickness: 6pt), 
  1, $X$, 1, targ(), 1, 
)
