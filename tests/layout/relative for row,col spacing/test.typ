#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  column-spacing: 1em,
  row-spacing: 1em,
  gate($H$), gate($H$), [\ ],
  gate($H$), 1
)

#pagebreak()

#quantum-circuit(
  min-row-height: 1em,
  min-column-width: 1em,
  gate($H$), gate($H$), [\ ],
  gate($H$), 1
)