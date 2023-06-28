#import "../../quantum-circuit.typ": *

#set page(width: 17.5cm, height: auto, margin: 2mm)


#let gallery = {
  table(align: center + horizon, columns: 6, column-gutter: (0pt, 0pt, 2.5pt, 0pt, 0pt),
    [Normal gate], quantum-circuit(1, gate($H$), 1), raw(lang: "typc", "gate($H$)"), 
    [Round gate], quantum-circuit(1, gate($X$, radius: 100%), 1), raw(lang: "typc", "gate($X$, \nradius: 100%)"), 
    [D gate], quantum-circuit(1, gate($Y$, radius: (right: 100%)), 1), raw(lang: "typc", "gate($Y$, radius: \n(right: 100%))"), 
    [Meter], quantum-circuit(1, meter(), 1), raw(lang: "typc", "meter()"), 
    [Meter with \ label], quantum-circuit(circuit-padding: (top: 1em), 1, meter(label: $lr(|±〉)$), 1), raw(lang: "typc", "meter(label: \n$lr(|±〉)$)"), 
    [Phase gate], quantum-circuit(1, phase($α$), 1), raw(lang: "typc", "phase($α$)"), 
    [Control], quantum-circuit(1, ctrl(0), 1), raw(lang: "typc", "ctrl(0)"), 
    [Open control], quantum-circuit(1, ctrl(0, open: true), 1), raw(lang: "typc", "ctrl(0, open: true)"), 
    [Target], quantum-circuit(1, targ(), 1), raw(lang: "typc", "targ()"), 
    [Swap target], quantum-circuit(1, targX(), 1), raw(lang: "typc", "targX()"), 
    [Permutation \ gate], quantum-circuit(1, permute(2,0,1), 1, [\ ], 3, [\ ], 3), raw(lang: "typc", "permute(2,0,1)"), 
    [Multiqubit \ gate], quantum-circuit(1, mqgate($U$, 3), 1, [\ ], 3, [\ ], 3), raw(lang: "typc", "mqgate($U$, 3)"), 
    [lstick], quantum-circuit(lstick($|psi〉$), 2), raw(lang: "typc", "lstick($|psi〉$)"), 
    [rstick], quantum-circuit(2, rstick($|psi〉$)), raw(lang: "typc", "rstick($|psi〉$)"), 
    [Multi-qubit \ lstick], quantum-circuit(row-spacing: 10pt, lstick($|psi〉$, n: 2), 2, [\ ], 3), raw(lang: "typc", "lstick($|psi〉$, \nn: 2)"), 
    [Multi-qubit \ rstick], quantum-circuit(row-spacing: 10pt,2, rstick($|psi〉$, n: 2, brace: "]"),[\ ], 3), raw(lang: "typc", "rstick($|psi〉$, \nn: 2, brace: \"]\")"), 
    [midstick], quantum-circuit(1, midstick("yeah"),1), raw(lang: "typc", "midstick(\"yeah\")"), 
    [Wire bundle], quantum-circuit(1, nwire(5), 1), raw(lang: "typc", "nwire(5)"), 
    [Controlled \  #smallcaps("z")-gate], quantum-circuit(1, ctrl(1), 1, [\ ], 1, ctrl(0), 1), [#raw(lang: "typc", "ctrl(1)") \ + \ #raw(lang: "typc", "ctrl(0)")], 
    [Controlled \  #smallcaps("x")-gate], quantum-circuit(1, ctrl(1), 1, [\ ], 1, targ(), 1), [#raw(lang: "typc", "ctrl(1)") \ + \ #raw(lang: "typc", "targ()")], 
    [Swap \  gate], quantum-circuit(1, swap(1), 1, [\ ], 1, targX(), 1), [#raw(lang: "typc", "swap(1)") \ + \ #raw(lang: "typc", "targX()")], 
    [Controlled \ Hadamard], quantum-circuit(1, controlled($H$, 1), 1, [\ ], 1, ctrl(0), 1), [#raw(lang: "typc", "controlled($H$, 1)") \ + \ #raw(lang: "typc", "ctrl(0)")], 
    [Meter to \ classical], quantum-circuit(1, meter(target: 1), 1, [\ ], setwire(2), 1, ctrl(0), 1), [#raw(lang: "typc", "meter(target: 1)") \ + \ #raw(lang: "typc", "ctrl(0)")],   
  )
}


#gallery