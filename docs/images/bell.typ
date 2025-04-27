#import "template.typ": *
#show: doc-image


// #let clr = if  "dark" not in sys.inputs { white } else { black }
// #set page(fill: white) if clr == black
// #set page(fill: none)
// #set text(fill: clr)


#import "/src/quill.typ" : *
#quantum-circuit(
  wire: .7pt, fill: none,
  lstick($|0〉$), gate($H$), ctrl(1), rstick($(|00〉+|11〉)/√2$, n: 2), [\ ],
  lstick($|0〉$), 1, targ(), 1
)