#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, ctrl(1), targ-y(1, wire-label: "d"), targ-y() ,targ-y(2, fill: gradient.linear(red, blue)), [\ ],
  1, targ-y(fill: none), ctrl(), 3, [\ ],
  1, targ-y(size: 20pt), targ-y(-1, size: -10pt, wire-count: 2), targ-y(size: 30pt, label: "Label")
)