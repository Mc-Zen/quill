#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, $H$, midstick($ρ$), $X$
)

#pagebreak()

#quantum-circuit(
  1, $H$, midstick($ρ$, fill: blue, label: ("label")), $X$
)

#pagebreak()
#quantum-circuit(
  baseline: .6fr,
    1, ctrl(1), targ(), ctrl(1), midstick("=", n: 2), swap(1), 1, [\ ],
    1, targ(), ctrl(-1), targ(), 1, swap(), 1, 
) 