
#import "/src/quill.typ": *

#set page(width: auto, height: auto, margin: 1pt)





// This is the one
#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 15pt, y: 4pt),
  quantum-circuit(
    row-spacing: 7pt,
    column-spacing: 18pt,
    wire: .6pt,
    scale: 130%,
    lstick($|psi〉$), gategroup(2,4, fill:blue.lighten(80%), stroke: (thickness: .7pt, dash: "dashed")),
    gate([Quill], radius: 2pt), ctrl(1), 1, 1, meter(target: 1), [\ ],
    setwire(2), 1, phantom(content: "X"), ctrl(0), 
    1, setwire(1, stroke: (thickness: .9pt, dash: "loosely-dotted")), 15pt, 1, 
    setwire(2, stroke: (dash: "solid", thickness: .6pt)), ctrl(0), 1, 

    annotate((3.9, 4), (0.1, 1.4), ((x0, x1), (y0, y1)) => {
      let x1 = x0 + 21.5pt
      place(
        curve(
          stroke: .7pt,
          curve.move((x0, y1)), 
          curve.cubic(none, (x1 - 20pt, y0 + 15pt), (x1, y0))
        )
      )
      let xp = x0 + .14*(x1 - x0)
      let yp = y0 + .7*(y1 - y0)
      place(
        curve(
          curve.move((xp, yp)), 
          curve.cubic(none, (x1 - 20pt, y0 + 15pt), (x1, y0)),
          // curve.cubic(none, (x1 - 14pt, y0 + 19pt), (xp, yp)),
          // curve.close(mode: "straight")
        )
      )
      place(
        curve(
          curve.move((xp, yp)), 
          curve.cubic(none, (x1 - 17pt, y0 + 15pt), (x1, y0))
        )
      )
      place(
        curve(
          curve.move((xp, yp)), 
          curve.cubic(none, (x1 - 14pt, y0 + 19pt), (x1, y0))
        )
      )
      
    })
  )
)
