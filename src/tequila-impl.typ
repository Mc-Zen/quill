#import "gates.typ"

/// A gate instance. 
#let bgate(

  /// Qubit or first qubit in the case of a multi-qubit gate. -> int
  qubit, 
  /// The gate type -> function. 
  constructor, 
  /// Number of qubits. -> int
  nq: 1, 

  /// ? -> array
  supplements: (), 

) = ((
  qubit: qubit,
  n: nq,
  supplements: supplements,
  constructor: constructor,
),)

#let generate-single-qubit-gate(
  qubit, 
  constructor: gates.gate, 
  ..args
) = {
  if qubit.named().len() != 0 {
    assert(false, message: "Unexpected argument `" + qubit.named().pairs().first().first() + "`")
  }
  qubit = qubit.pos()
  if qubit.len() == 1 { qubit = qubit.first() }
  if type(qubit) == int { return bgate(qubit, constructor.with(..args)) }
  qubit.map(qubit => bgate(qubit, constructor.with(..args)))
}


/// Generates a two-qubit gate with two qubits connected by a wire. 
#let generate-two-qubit-gate(

  /// Control qubit(s). 
  /// -> int | array
  qubit1, 

  /// Target qubit(s). 
  /// -> int | array
  qubit2, 

  /// Gate to put at the control qubit. This gate needs to take a
  /// single positional argument: the relative target number. 
  /// -> function
  gate1, 

  /// Gate to put at the target qubit. 
  /// -> function
  gate2

) = {
  if type(qubit1) == int and type(qubit2) == int { 
    assert.ne(qubit2, qubit1, message: "Target and control qubit cannot be the same")
    return bgate(
      qubit1,
      gate1.with(qubit2 - qubit1),
      nq: qubit2 - qubit1 + 1,
      supplements: ((qubit2, gate2),)
    ) 
  }
  if type(qubit1) == int { qubit1 = (qubit1,) }
  if type(qubit2) == int { qubit2 = (qubit2,) }

  range(calc.max(qubit1.len(), qubit2.len())).map(i => {
    let c = qubit1.at(i, default: qubit1.last())
    let t = qubit2.at(i, default: qubit2.last())
    assert.ne(t, c, message: "Target and control qubit cannot be the same")
    bgate(
      c, 
      gate1.with(t - c), 
      nq: t - c + 1, 
      supplements: ((t, gate2),)
    )
  })
}

/// Creates a gate with multiple controls. 
#let generate-multi-controlled-gate(

  /// Control qubits. 
  /// -> array
  controls, 

  /// Target qubit(s). 
  /// -> int | array
  qubit, 

  /// Gate to put at the target. 
  /// -> function
  gate

) = {
  let sort-ops(cs, q) = {
    let k = cs.map(c => (c, gates.ctrl.with(0))) + ((q, gate),)
    k = k.sorted(key: x => x.first())
    let n = k.last().at(0) - k.first().at(0)
    if k.first().at(1) == gates.ctrl.with(0) { k.first().at(1) = gates.ctrl.with(n) }
    else if k.last().at(1) == gates.ctrl.with(0) { k.at(2).at(1) = gates.ctrl.with(-n) }
    return k
  }
  controls = controls.map(c => if type(c) == int { (c,) } else { c })
  if type(qubit) == int { qubit = (qubit,) }

  range(calc.max(qubit.len(), ..controls.map(array.len))).map(i => {
    let q = qubit.at(i, default: qubit.last())
    let cs = controls.map(c => c.at(i, default: c.last()))
    assert((cs + (q,)).dedup().len() == cs.len() + 1, message: "Target and control qubits need to be all different (were " + str(q) + " and " + repr(cs) + ")")
    let ops = sort-ops(cs, q)
    bgate(
      ops.first().at(0), ops.first().at(1), 
      nq: ops.last().at(0) - ops.first().at(0) + 1, 
      supplements: ops.slice(1)
    )
  })
}


#let gate(qubit, ..args) = bgate(qubit, gates.gate.with(..args))

#let mqgate(qubit, n: 1, ..args) = {
  bgate(qubit, nq: n, gates.mqgate.with(..args, n: n))
}

#let barrier() = bgate(0, barrier)

#let x(..qubit) = generate-single-qubit-gate(qubit, $X$)
#let y(..qubit) = generate-single-qubit-gate(qubit, $Y$)
#let z(..qubit) = generate-single-qubit-gate(qubit, $Z$)

#let h(..qubit) = generate-single-qubit-gate(qubit, $H$)
#let s(..qubit) = generate-single-qubit-gate(qubit, $S$)
#let sdg(..qubit) = generate-single-qubit-gate(qubit, $S^dagger$)
#let sx(..qubit) = generate-single-qubit-gate(qubit, $sqrt(X)$)
#let sxdg(..qubit) = generate-single-qubit-gate(qubit, $sqrt(X)^dagger$)
#let t(..qubit) = generate-single-qubit-gate(qubit, $T$)
#let tdg(..qubit) = generate-single-qubit-gate(qubit, $T^dagger$)
#let p(theta, ..qubit) = generate-single-qubit-gate(qubit, $P (#theta)$)

#let rx(theta, ..qubit) = generate-single-qubit-gate(qubit, $R_x (#theta)$)
#let ry(theta, ..qubit) = generate-single-qubit-gate(qubit, $R_y (#theta)$)
#let rz(theta, ..qubit) = generate-single-qubit-gate(qubit, $R_z (#theta)$)

#let u(theta, phi, lambda, ..qubit) = generate-single-qubit-gate(
  qubit, $U (#theta, #phi, #lambda)$
)

#let meter(..qubit) = generate-single-qubit-gate(qubit, constructor: gates.meter)


#let cx(control, target) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.targ
)
#let cz(control, target) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.ctrl.with(0)
)
#let swap(control, target) = generate-two-qubit-gate(
  control, target, gates.swap, gates.swap.with(0)
)
#let ccx(control1, control2, target) = generate-multi-controlled-gate(
  (control1, control2), target, gates.targ
)
#let cccx(control1, control2, control3, target) = generate-multi-controlled-gate(
  (control1, control2, control3), target, gates.targ
)
#let ccz(control1, control2, target) = generate-multi-controlled-gate(
  (control1, control2), target, gates.ctrl.with(0)
)
#let cca(control1, control2, target, content) = generate-multi-controlled-gate(
  (control1, control2), target, gates.gate.with(content)
)


#let ca(control, target, content) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.gate.with(content)
)

#let multi-controlled-gate(controls, qubit, target) = generate-multi-controlled-gate(
  controls, qubit, target
)


/// Constructs a circuit from operation instructions. 
#let build(

  /// Number of qubits. Can be inferred automatically. 
  /// -> auto | int 
  n: auto, 
  /// Determines at which column the subcircuit will be put in the circuit. 
  /// -> int 
  x: 1, 
  /// Determines at which row the subcircuit will be put in the circuit. 
  /// -> int 
  y: 0,
  /// If set to `true`, the a last column of outgoing wires will be added. 
  /// -> bool
  append-wire: true,
  /// Sequence of instructions. 
  /// -> any
  ..children

) = {
  let operations = children.pos().flatten()
  let num-qubits = n
  if num-qubits == auto {
    num-qubits = calc.max(..operations.map(x => x.qubit + calc.max(0, x.n - 1))) + 1
  }
  let tracks = ((),) * num-qubits
  
  for op in operations {
    let start = op.qubit
    // if start < 0 { start = num-qubits + start }
    let end = start + op.n - 1
    assert(start >= 0 and start < num-qubits, message: "The qubit `" + str(start) + "` is out of range. Leave `n` at `auto` if you want to automatically resize the circuit. ")
    assert(end >= 0 and end < num-qubits, message: "The qubit `" + str(end) + "` is out of range. Leave `n` at `auto` if you want to automatically resize the circuit. ")
    let (q1, q2) = (start, end).sorted()
    if op.constructor == barrier {
      (q1, q2) = (0, num-qubits - 1)
    }
    let max-track-len = calc.max(..tracks.slice(q1, q2 + 1).map(array.len))
    let h = (q1, q2)
    let h = (start,) + op.supplements.map(x => x.first())
    for q in range(q1, q2 + 1) {
      let dif = max-track-len - tracks.at(q).len()
      if op.constructor != barrier and q not in h {
         dif += 1
      }
      tracks.at(q) += (1,) * dif
    }
    if op.constructor != barrier {
      tracks.at(start).push((op.constructor)(x: x + tracks.at(start).len(), y: y + start))
      for (qubit, supplement) in op.supplements {
        tracks.at(qubit).push((supplement)(x: x + tracks.at(end).len(), y: y + qubit))
      }
    }
  }
  
  let max-track-len = calc.max(..tracks.map(array.len)) + 1
  for q in range(tracks.len()) {
    tracks.at(q) += (1,) * (max-track-len - tracks.at(q).len())
  }
  
  let num-cols = x + calc.max(..tracks.map(array.len)) - 2
  if append-wire { num-cols += 1 }
  let placeholder = gates.gate(
    none, 
    x: num-cols, y: y + num-qubits - 1, 
    data: "placeholder", box: false, floating: true, 
    size-hint: (it, i) => (width: 0pt, height: 0pt)
  )

  (placeholder,) + tracks.flatten().filter(x => type(x) != int) 
}



/// Constructs a graph state preparation circuit. 
#let graph-state(

  /// Number of qubits. Can be inferred automatically. 
  /// -> auto | int
  n: auto,
  /// Determines at which column the subcircuit will be put in the circuit. 
  /// -> int 
  x: 1,
  /// Determines at which row the subcircuit will be put in the circuit. 
  /// -> int 
  y: 0,
  /// If set to `true`, the circuit will be inverted, i.e., a circuit for
  /// "uncomputing" the corresponding graph state. 
  /// -> bool
  invert: false,
  /// -> array
  ..edges

) = {
  edges = edges.pos()
  let max-qubit = 0
  for edge in edges {
    assert(type(edge) == array, message: "Edges need to be pairs of vertices")
    assert(edge.len() == 2, message: "Every edge needs to have exactly two vertices")
    max-qubit = calc.max(max-qubit, ..edge)
  }
  let num-qubits = max-qubit + 1
  if n != auto {
    num-qubits = n
    assert(n > max-qubit, message: "")
  }
  let gates = (
    h(range(num-qubits)),
    barrier(),
    edges.map(edge => cz(..edge))
  )
  if invert {
    gates = gates.rev()
  }
  build(
    x: x, y: y, 
    ..gates
  )
}


/// Template for the quantum fourier transform (QFT). 
#let qft(

  /// Number of qubits. 
  /// -> auto | int
  n, 
  /// - x (int): Determines at which column the QFT routine will be placed in the circuit. 
  /// -> int 
  x: 1, 
  /// - y (int): Determines at which row the QFT routine will be placed in the circuit. 
  /// -> int 
  y: 0
  
) = {
  let gates = ()
  for i in range(n - 1) {
    gates.push(h(i))
    for j in range(2, n - i + 1) {
      gates.push(ca(i + j - 1, i, $R_#j$))
      gates.push(p(i + j - 1))
    }
    gates.push(barrier())
  }
  gates.push(h(n - 1))
  build(n: n, x: x, y: y, ..gates)
}
