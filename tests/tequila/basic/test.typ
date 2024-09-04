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
    tq.h(0,1), 
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
  tq.barrier(),
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
  tq.h(0, 1, 2)
))



#pagebreak()

#quill.quantum-circuit(..tq.build(
  append-wire: false,
  tq.s(0, 1, 2),
  tq.meter(range(1,3)),
))

