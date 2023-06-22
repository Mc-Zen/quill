#import "../quantum-circuit.typ": *



#let teleportation = quantum-circuit(
  lstick($|psi〉$),  control(1), gate($H$), 1, ctrl(), meter(), [\ ],
  lstick($|beta_00〉$, num-qubits: 2), targ(), 1, ctrl(), 1, meter(), [\ ],
  3, controlled($X$, -1), controlled($Z$, -2),  midstick($|psi〉$)
)


#let phase-estimation = quantum-circuit(
  setwire(0), lstick(align(center)[First register\ $t$ qubits], num-qubits: 4), lstick($|0〉$), setwire(1), gate($H$), 4, midstick($ dots $), control(4), rstick($|0〉$), [\ ], 10pt,
  setwire(0), phantom(width: 13pt), lstick($|0〉$), setwire(1), gate($H$), 2, control(3), 1, midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), gate($H$), 1, control(2), 2, midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), 1, lstick($|0〉$), setwire(1), gate($H$), control(1), 3, midstick($ dots $), 1, rstick($|0〉$), [\ ],
  setwire(0), lstick([Second register], num-qubits: 1, brace: "{"), lstick($|u〉$), setwire(4, wire-distance: 1.3pt), 1, gate($ U^2^0 $, -1), gate($ U^2^1 $, -2), gate($ U^2^2 $, -3), 1, midstick($ dots $), gate($ U^2^(t-1) $, -5), rstick($|u〉$)
)


#let qft = quantum-circuit(
  scale-factor: 85%,
  row-spacing: 5pt,
  column-spacing: 8pt,
  lstick($|j_1〉$), gate($H$), controlled($R_2$, 1), midstick($ dots $), controlled($R_(n-1)$, 3), controlled($R_n$, 4), 8, rstick($|0〉+e^(2pi i 0.j_1 dots j_n)|1〉$),[\ ],
  lstick($|j_2〉$), 1, ctrl(), midstick($ dots $), 2, gate($H$), midstick($ dots $), controlled($R_(n-2)$, 2), controlled($R_(n-1)$, 3), midstick($ dots $), 3, rstick($|0〉+e^(2pi i 0.j_2 dots j_n)|1〉$), [\ ],
  
  setwire(0),  midstick($dots.v$), 1, midstick($dots.v$), [\ ],
  
  lstick($|j_(n-1)〉$), 3, ctrl(), 3, ctrl(), 1, midstick($ dots $), gate($H$), controlled($R_(2)$, 1), 1, rstick($|0〉+e^(2pi i 0.j_(n-1)j_n)|1〉$), [\ ],
  lstick($|j_n〉$), 4, ctrl(), 3, ctrl(), midstick($ dots $), 1, ctrl(), gate($H$), rstick($|0〉+e^(2pi i 0.j_n)|1〉$)
)


#let shor9 = quantum-circuit(
  lstick($|ψ〉$), 1, 10pt, control(3), control(6), gate($H$), 1, 15pt, control(1), control(2), 1, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), targ(), 2, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), 1, targ(), 1, [\ ],
  lstick($|0〉$), 1, targ(), 1, gate($H$), 1, control(1), control(2), 1, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), targ(), 2, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), 1, targ(), 1, [\ ],
  lstick($|0〉$), 2, targ(),  gate($H$), 1, control(1), control(2), 1, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), targ(), 2, [\ ],
  setwire(0), 5, lstick($|0〉$), setwire(1), 1, targ(), 1, [\ ],
)

#let fault-tolerant-measurement = {
  let mark(text, col1, col2) = annotate(0, (col1, col2),
    (y, (x1, x2)) => style(styles => {
      let size = measure(text, styles)
      place(dx: x1 + (x2 - x1)/2 - size.width/2, dy: y - .6em - size.height, text)
    })
  )
  let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))
  quantum-circuit(
    row-spacing: 6pt,
    circuit-padding: (top: 2em),
    lstick($|0〉$), 10pt, group(3, 2), gate($H$), control(2), 3pt, group(4, 2), 3, group(7, 3), control(4), 2, 10pt, group(3, 2), control(2), gate($H$), meter(), [\ ],  
    lstick($|0〉$), 1, targ(), 1, control(2), 2, control(4), 1, targ(), 2, [\ ], 
    lstick($|0〉$), 1, targ(), control(1), 4, control(4), targ(), 2, [\ ],  
    setwire(0), 2, lstick($|0〉$), setwire(1), targ(), targ(), 1, [\ ], 10pt,
    setwire(0), 4, lstick(align(center)[Encoded\ Data], num-qubits: 3), setwire(1), 1, gate($M'$), 3, [\ ],
    setwire(0), 5,  setwire(1), 2, gate($M'$), 2, [\ ],
    setwire(0), 5,  setwire(1), 3, gate($M'$), 1,
    mark("Prepare", 1, 3),
    mark("Verify", 3, 5),
    mark([Controlled-$M$], 5, 9),
    mark("Decode", 9, 11)
  )
}

#let fault-tolerant-pi8 = [
  #let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))
  
  #quantum-circuit(
    group(1, 4, padding: (left: 1.5em)), lstick($|0〉$), nwire(""), gate($H$), gate($T$), control(1), gate($S X$), rstick($T|ψ〉$), [\ ],
    lstick($|ψ〉$), nwire(""), 2, targ(), meter(target: -1), 
  )
]

#let fault-tolerant-toffoli1 = {
  quantum-circuit(
    lstick($|0〉$), gate($H$), control(3), 5, gate($X$), control(2), rstick($|x〉$), [\ ],
    lstick($|0〉$), gate($H$), 1, control(3), 3, gate($X$), 1, ctrl(), rstick($|y〉$), [\ ],
    lstick($|0〉$), 3, targ(), 1, gate($Z$), 2, targ(), rstick($|z plus.circle x y〉$), [\ ],
    lstick($|x〉$), 1, targ(), 5, meter(target: -3), [\ ],
    lstick($|y〉$), 2, targ(), 3, meter(target: -3), [\ ],
    lstick($|z〉$), 3, control(-3), gate($H$), meter(target: -3)
  )
}

#let fault-tolerant-toffoli2 = [
  #let group = gategroup.with(stroke: (dash: "dotted", thickness: .5pt))
  
  #quantum-circuit(
    group(3, 3, padding: (left: 1.5em)), lstick($|0〉$), gate($H$), control(2), control(3), 3, group(2, 1), control(1), 1, group(3, 1),  control(2), gate($X$), 1, rstick($|x〉$), [\ ],
    lstick($|0〉$), gate($H$), ctrl(), 1, control(3), 2, gate($Z$), gate($X$), 2, group(2, 1), control(1), rstick($|y〉$), [\ ],
    lstick($|0〉$), 1, targ(), 2, targ(), 1, gate($Z$), 1, targ(fill: true), 1, targ(fill: true), rstick($|z plus.circle x y〉$), [\ ],
    lstick($|x〉$), 2, targ(), 6, meter(target: -3), setwire(2), control(-1, wire-count: 2), [\ ],
    lstick($|y〉$), 3, targ(), 3, meter(target: -3), setwire(2), control(-2, wire-count: 2), [\ ],
    lstick($|z〉$), 4, control(-3), gate($H$), meter(target: -4)
  )
]
