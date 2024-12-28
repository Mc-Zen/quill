#set page(width: auto, height: auto, margin: 0pt)

#let clr = if  "dark" not in sys.inputs { white } else { black }
#set page(fill: white) if clr == black
#set page(fill: black)
#set text(fill: clr)

#let scale-factor = 100%
#let content = include("/examples/composition.typ")

#scale(130%, reflow: true)[
  #import "/src/quill.typ" : *
  #quantum-circuit(
    color: clr, wire: .7pt + clr, fill: none,
    lstick($|0〉$), gate($H$), ctrl(1), rstick($(|00〉+|11〉)/√2$, n: 2), [\ ],
    lstick($|0〉$), 1, targ(), 1
  )
]