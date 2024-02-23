#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#box(fill: red, quantum-circuit(
  column-spacing: 0pt,
  row-spacing: 0pt,
  10pt /*should be ignored*/, 
  gate($H$), 5pt, 10pt, 5pt, gate($H$), 10pt, gate($H$), [\ ], 10pt,
  gate($H$), gate($H$), gate($H$), [\ ], 10pt, 20pt,
  gate($H$), gate($H$),20pt, gate($H$), 
))