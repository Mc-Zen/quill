#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  lstick("a"), gate($H$), rstick("b"), [\ ],
  1, gate($H$), rstick($mat(a,b;c,d,)$, n: 3), [\ ],
  lstick("asd", n: 2), gate($H$), 1, [\ ],
  1, gate($T$), 1
)

#pagebreak()

#quantum-circuit(
  lstick("single with brace", brace: "{"), gate($H$), rstick("b", brace: "]"), [\ ],
  1, gate($H$), rstick($mat(a,b;c,d)$, n: 3, brace: none), [\ ],
  lstick("nobrace", n: 2, brace: none), gate($H$), 1, [\ ],
  1, gate($T$), 1
)

#pagebreak()

#quantum-circuit(
  1, gate($H$), rstick($mat(a,b;c,d)$, n: 3, brace: "|"), [\ ],
  lstick("[-brace", n: 2, brace: "["), gate($H$), 1, [\ ],
  1, gate($T$), 1
)

#pagebreak()

#quantum-circuit(
  lstick("very long lstick"), 1
)

#pagebreak()

#quantum-circuit(
  1, rstick("very long rstick")
)

#pagebreak()

// lstick with equation numbering
#set math.equation(numbering: "1")
#quantum-circuit(
  lstick($|0〉$, brace: "{"), 1
)

#pagebreak()

#quantum-circuit(
  lstick($|0〉$, brace: "{", pad: 10pt), 1, rstick($|0〉$, brace: "}", pad: 10pt)
)
