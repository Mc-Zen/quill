#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#let draw-par-gate(gate, draw-params) = {
  let stroke = draw-params.wire
  let fill = if gate.fill != none { gate.fill } else {draw-params.background }
  box(
    gate.content, 
    fill: fill, stroke: (left: stroke, right: stroke), 
    inset: draw-params.padding
    )
}

#box(quantum-circuit(
  1, gate("Quill", draw-function: draw-par-gate), 1, 
), fill: gray)