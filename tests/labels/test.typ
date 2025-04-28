#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#let labels-everywhere = (
    (content: "lt", pos: left + top),
    (content: "t", pos: top),
    (content: "rt", pos: right + top),
    (content: "l", pos: left),
    (content: "c", pos: center),
    (content: "r", pos: right),
    (content: "lb", pos: left + bottom),
    (content: "b", pos: bottom),
    (content: "rb", pos: right + bottom),
  )
#quantum-circuit(
  gate(hide[H], label: labels-everywhere), 
)

#pagebreak()

#quantum-circuit(
  1, mqgate(hide[Gate], n: 2, label: labels-everywhere), 1, [\ ],
  3, 
)

#pagebreak()

#quantum-circuit(
  gategroup(1, 2, label: labels-everywhere), gate($X$), gate($Y$), 
)

#pagebreak()

#quantum-circuit(
  1, ctrl(label: (content: "al", pos: right + top)), 1
)

#pagebreak()

#quantum-circuit(
  1, slice(label: labels-everywhere), 1, [\ ],
  2, [\ ],
  2, [\ ],
  2, [\ ],
  2, [\ ],
  2, 
)

#pagebreak()

#quantum-circuit(
  gate("H", label: ((content: "H", pos: left, dx: 0pt, dy: 0pt))),  
)

#pagebreak()

#quantum-circuit(
  gate("H", label: ((content: "H", pos: bottom, dx: 0pt, dy: 0pt)))
)

#pagebreak()

#quantum-circuit(
  2, slice(label: (content: "E", pos: top)), 
  gategroup(1,2,padding: 1em, radius: 2em, label: (content: "E", pos: bottom)), gate($H$, label: (content: "E", pos: top, dx: 50% + 2em, dy: 50%)), 2,
)

#pagebreak()

#quantum-circuit(
  1, $H$, 1, $H$,[H],$I$, $S$, "H", [\ ],
  lstick($|0〉$, label: "System 1"), gate($H$, label: "a"), 1, midstick("mid", label: (content: "r", pos: bottom)), 1, rstick($F$, label: "a"), setwire(0)
)