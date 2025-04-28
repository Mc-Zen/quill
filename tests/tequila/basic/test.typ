#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ"
#import quill: tequila as tq

#quill.quantum-circuit(
  ..tq.build(
    tq.h(0),
    tq.cx(0, 1),
    tq.cx(0, 2),
  )
)

#pagebreak()


#quill.quantum-circuit(
  ..tq.build(
    n: 3,
    tq.h((0,1)), 
    tq.gate(1, $Pi$, fill: orange), 
    tq.mqgate(0, "E", n: 2, fill: yellow)
  )
)

#pagebreak()


#quill.quantum-circuit(..tq.build(
  tq.x(0), tq.y(0), tq.z(0), 
  tq.h(0), tq.s(0), tq.sdg(0), tq.sx(0), tq.sxdg(0), 
  tq.t(0), tq.tdg(0), tq.p($theta$, 0),
))

#pagebreak()


#quill.quantum-circuit(..tq.build(
  tq.rx($theta$, 0), tq.ry($theta$, 0), tq.rz($theta$, 0), tq.u($pi$, $0$, $lambda$, 0)
))

#pagebreak()

#quill.quantum-circuit(..tq.build(
  tq.h(range(2)), 
  tq.t(3),
  tq.h(0),
  tq.h(5),
  // tq.barrier(),
  tq.cx(2,1),
  tq.cx(1,2),
  tq.cz(1,2),
  tq.swap(1,2),
))

#pagebreak()

#quill.quantum-circuit(..tq.build(
  tq.h(range(5)), 
  tq.cz(1,2),
  tq.cz(3,4),
  tq.x(3),
  tq.cz(0, range(1,5))
))



#pagebreak()

#quill.quantum-circuit(..tq.build(
  tq.cz(0, 2),
  tq.h((0, 1, 2))
))



#pagebreak()

#quill.quantum-circuit(..tq.build(
  append-wire: false,
  tq.s((0, 1, 2)),
  tq.meter(range(1,3)),
))



#pagebreak()

#quill.quantum-circuit(..tq.build(
  tq.ccx((0, 1, 2, 1, 0, 2), (1, 0, 1, 2, 2, 0), (2, 2, 0, 0, 1, 1)),
  tq.ccx(2, 4, 1),
  tq.ccz(2, 3, 1),
  tq.y(1),
  tq.cca(1, 4, 2, $X$),
  tq.h(range(5)),
  tq.cccx(0, 1, 3, 2),
  tq.multi-controlled-gate((0,1,4), 2, quill.mqgate.with(n:2, $K$)),
  tq.multi-controlled-gate((1,), 0, quill.gate.with($Y$))
))


#pagebreak()

#quill.quantum-circuit(..tq.build(
  tq.measure(0),
  tq.measure(2, 1),
  tq.measure(1, 2),
))


#pagebreak()

#quill.quantum-circuit(..tq.build(
  n: 5,
  tq.x(0),
  tq.barrier(start: 0, end: 2),
  tq.h(range(5))
))


#pagebreak()

#quill.quantum-circuit(
  import tq: *,
  ..tq.build(
    n: 6,
    import tq: *,
    h(0),
    h(1),
    cx(1, 0),
    cx(1, 3),
    measure(1, 4),
    barrier(start: 0, end: 1),
  ),
  [\ ],
  [\ ],
  [\ ],
  [\ ],
  quill.setwire(2)
)