#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ" as quill: tequila as tq


#quill.quantum-circuit(
  ..tq.graph-state((1,2), (0,2), (0,3), (0,1), (2,3))
)

#pagebreak()

#quill.quantum-circuit(
  ..tq.graph-state((1,2), (0,2), (0,3), (0,1), (2,3), n: 6), 
 )