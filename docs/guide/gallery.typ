#import "../../src/quill.typ": *

#set page(width: 17.5cm, height: auto, margin: 2mm)


#let gallery = {
  set raw(lang: "typc")
  table(
    align: center + horizon, 
    columns: (1fr, 1fr, 1.3fr, 1.1fr, 1fr, 1.48fr), 
    column-gutter: (0pt, 0pt, 2.5pt, 0pt, 0pt),
    
    [Normal gate], quantum-circuit(1, gate($H$), 1), raw("gate($H$)"), 
    [Round gate], quantum-circuit(1, gate($X$, radius: 100%), 1), raw("gate($X$, \nradius: 100%)"), 
    [D gate], quantum-circuit(1, gate($Y$, radius: (right: 100%)), 1), raw("gate($Y$, radius: \n(right: 100%))"), 
    [Meter], quantum-circuit(1, meter(), 1), raw("meter()"), 
    [Meter with \ label], quantum-circuit(1, meter(label: $lr(|±〉)$), 1), raw("meter(label: \n$lr(|±〉)$)"), 
    [Phase gate], quantum-circuit(1, phase($α$), 1), raw("phase($α$)"), 
    [Control], quantum-circuit(1, ctrl(0), 1), raw("ctrl(0)"), 
    [Open control], quantum-circuit(1, ctrl(0, open: true), 1), raw("ctrl(0, open: true)"), 
    [Target], quantum-circuit(1, targ(), 1), raw("targ()"), 
    [Swap target], quantum-circuit(1, targX(), 1), raw("targX()"), 
    [Permutation \ gate], quantum-circuit(1, permute(2,0,1), 1, [\ ], 3, [\ ], 3), raw("permute(2,0,1)"), 
    [Multiqubit \ gate], quantum-circuit(1, mqgate($U$, n: 3), 1, [\ ], 3, [\ ], 3), raw("mqgate($U$, 3)"), 
    [lstick], quantum-circuit(lstick($|psi〉$), 2), raw("lstick($|psi〉$)"), 
    [rstick], quantum-circuit(2, rstick($|psi〉$)), raw("rstick($|psi〉$)"), 
    [Multi-qubit \ lstick], quantum-circuit(row-spacing: 10pt, lstick($|psi〉$, n: 2), 2, [\ ], 3), raw("lstick($|psi〉$, \nn: 2)"), 
    [Multi-qubit \ rstick], quantum-circuit(row-spacing: 10pt,2, rstick($|psi〉$, n: 2, brace: "]"),[\ ], 3), raw("rstick($|psi〉$, \nn: 2, brace: \"]\")"), 
    [midstick], quantum-circuit(1, midstick("yeah"),1), raw("midstick(\"yeah\")"), 
    [Wire bundle], quantum-circuit(1, nwire(5), 1), raw("nwire(5)"), 
    [Controlled \  #smallcaps("z")-gate], quantum-circuit(1, ctrl(1), 1, [\ ], 1, ctrl(0), 1), [#raw("ctrl(1)") \ + \ #raw("ctrl(0)")], 
    [Controlled \  #smallcaps("x")-gate], quantum-circuit(1, ctrl(1), 1, [\ ], 1, targ(), 1), [#raw("ctrl(1)") \ + \ #raw("targ()")], 
    [Swap \  gate], quantum-circuit(1, swap(1), 1, [\ ], 1, targX(), 1), [#raw("swap(1)") \ + \ #raw("targX()")], 
    [Controlled \ Hadamard], quantum-circuit(1, mqgate($H$, target: 1), 1, [\ ], 1, ctrl(0), 1), [#raw("mqgate($H$,target:1)") \ + \ #raw("ctrl(0)")],
    [Plain\ vertical\ wire], quantum-circuit(1, ctrl(1, show-dot: false), 1, [\ ], 3), raw("ctrl(1, show-dot: false)"),
    [Meter to \ classical], quantum-circuit(1, meter(target: 1), 1, [\ ], setwire(2), 1, ctrl(0), 1), [#raw("meter(target: 1)") \ + \ #raw("ctrl(0)")],   
    [Classical wire], quantum-circuit(setwire(2), 3), raw("setwire(2)"), [Styled wire], quantum-circuit(setwire(1, stroke: green), 3), raw("setwire(1, stroke: green)"),
    [], [],[],[Gate inputs \ and outputs],
    quantum-circuit(scale: 80%,
      1, mqgate($U$, n: 3, width: 5em,
        inputs: (
          (qubit: 0, n: 2, label: $x$),
          (qubit: 2, label: $y$)
        ),
        outputs: (
          (qubit: 0, n: 2, label: $x$),
          (qubit: 2, label: $y ⊕ f(x)$)
        ),
      ), 1, [\ ], 3, [\ ], 3
    ),
    [#set text(size: .6em);```typc
    mqgate($U$, n: 3, width: 5em,
      inputs: (
        (qubit:0, n:2, label:$x$),
        (qubit:2, label: $y$)
      ),
      outputs: (
        (qubit:0, n:2, label:$x$),
        (qubit:2, label:$y⊕f(x)$)
      )
    )```]
  )
}


#gallery