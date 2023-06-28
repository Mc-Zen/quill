
#import "../quantum-circuit.typ": *

#set page(width: auto, height: auto, margin: 2pt)

// #quantum-circuit(
//   1, gate("Quantum"), control(1),2, [\ ],
//   2, ctrl(), gate("Circui"), gate($T$)
// )
// #v(2cm)

// #quantum-circuit(
//   // background: blue.lighten(90%),
//   row-spacing: 8pt,
//   lstick($|psi〉$), gategroup(2,3, fill:blue.lighten(80%), stroke: (thickness: .7pt, dash: "dashed"), radius: 2pt),gate("Quantum"), control(1),1, meter(target: 1), [\ ],
//   setwire(2), 2, ctrl(), gate("Circuit"), ctrl(), 1
// )
// #v(2cm)



// This is the one
#quantum-circuit(
  row-spacing: 7pt,
  column-spacing: 15pt,
  wire: .6pt,
  lstick($|psi〉$), gategroup(2,3, fill:blue.lighten(80%), stroke: (thickness: .7pt, dash: "dashed")), 
  gate("Quantum", radius: 2pt), ctrl(1),1, meter(target: 1), [\ ],
  setwire(2), 2, ctrl(0), gate("Circuit", radius: 2pt), ctrl(0), 1
)



// #v(2cm)

// #quantum-circuit(
//   row-spacing: 8pt,
//   lstick($|psi〉$),  gategroup(2,3, fill:blue.lighten(80%)), gate([Quantum]), control(1),1, swap(1),1, [\ ],
//   setwire(2), 2, ctrl(), gate("Circuit"), targX,1
// )