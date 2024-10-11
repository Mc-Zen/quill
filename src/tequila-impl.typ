#import "gates.typ"

#let bgate(qubit, constructor, nq: 1, supplements: (), end: none, ..args) = ((
  qubit: qubit,
  n: nq,
  end: end,
  supplements: supplements,
  constructor: constructor,
  args: args
),)

#let generate-single-qubit-gate(qubit, constructor: gates.gate, ..args) = {
  if qubit.named().len() != 0 {
    assert(false, message: "Unexpected argument `" + qubit.named().pairs().first().first() + "`")
  }
  qubit = qubit.pos()
  if qubit.len() == 1 { qubit = qubit.first() }
  if type(qubit) == int { return bgate(qubit, constructor, ..args) }
  qubit.map(qubit => bgate(qubit, constructor, ..args))
}

#let generate-two-qubit-gate(control, target, start, end) = {
  if type(control) == int and type(target) == int { 
    assert.ne(target, control, message: "Target and control qubit cannot be the same")
    return bgate(
      control,
      start,
      target - control,
      nq: target - control + 1,
      end: end,
      supplements: ((target, end),)
    ) 
  }
  let gates = ()
  if type(control) == int { control = (control,) }
  if type(target) == int { target = (target,) }

  for i in range(calc.max(control.len(), target.len())) {
    let c = control.at(i, default: control.last())
    let t = target.at(i, default: target.last())
    assert.ne(t, c, message: "Target and control qubit cannot be the same")
    gates.push(bgate(c, start, nq: t - c + 1, end: end, t - c, supplements: ((t, end),)))
  }
  gates
}

#let generate-doubly-controlled-gate(control1, control2, target, end) = {
  let sort-targets(c1, c2, t) = {
    let k = ((c1, gates.ctrl.with(0)), (c2, gates.ctrl.with(0)), (t, end))
    k = k.sorted(key: x => x.first())
    let n = k.at(2).first() - k.at(0).first()
    if k.at(0).last() == gates.ctrl.with(0) { k.at(0).last() = gates.ctrl.with(n) }
    else if k.at(2).last() == gates.ctrl.with(0) { k.at(2).last() = gates.ctrl.with(-n) }
    return k
  }
  if type(control1) == int and type(control2) == int and type(target) == int { 
    assert((target, control1, control2).dedup().len() == 3, message: "Target and control qubits need to be all different")
    let (a, b, c) = sort-targets(control1, control2, target)
    return bgate(
      a.first(), a.last(), 
      nq: c.first() - a.first() + 1, 
      end: end, 
      supplements: (b, c)
    ) 
  }
  let gates = ()
  if type(control1) == int { control1 = (control1,) }
  if type(control2) == int { control2 = (control1,) }
  if type(target) == int { target = (target,) }

  for i in range(calc.max(control1.len(), control2.len(), target.len())) {
    let c1 = control1.at(i, default: control1.last())
    let c2 = control2.at(i, default: control2.last())
    let t = target.at(i, default: target.last())
    assert((t, c1, c2).dedup().len() == 3, message: "Target and control qubits need to be all different")
    let (a, b, c) = sort-targets(c1, c2, t)
    gates.push(bgate(
      a.first(), a.last(), 
      nq: c.first() - a.first() + 1, 
      end: end, 
      supplements: (b, c)
    ))
  }
  gates
}


#let gate(qubit, ..args) = bgate(qubit, gates.gate, ..args)

#let mqgate(qubit, n: 1, ..args) = {
  bgate(qubit, nq: n, gates.mqgate, ..args.pos(), ..args.named() + (n: n))
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
#let ccx(control1, control2, target) = generate-doubly-controlled-gate(
  control1, control2, target, gates.targ
)
#let ccz(control1, control2, target) = generate-doubly-controlled-gate(
  control1, control2, target, gates.ctrl.with(0)
)
#let cca(control1, control2, target, content) = generate-doubly-controlled-gate(
  control1, control2, target, gates.gate.with(content)
)


#let ca(control, target, content) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.gate.with(content)
)


/// Constructs a circuit from operation instructions. 
/// 
/// - n (auto, int): Number of qubits. Can be inferred automatically. 
/// - x (int): Determines at which column the subcircuit will be put in the circuit. 
/// - y (int): Determines at which row the subcircuit will be put in the circuit. 
/// - append-wire (boolean): If set to `true`, the a last column of outgoing wires will be added. 
/// - ..children (any): Sequence of instructions. 
#let build(
  n: auto, 
  x: 1, 
  y: 0,
  append-wire: true,
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
      tracks.at(start).push((op.constructor)(..op.args, x: x + tracks.at(start).len(), y: y + start))
      if op.end != none {
        // tracks.at(end).push((op.end)(x: x + tracks.at(end).len(), y: y + end))
      }
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
/// 
/// - n (auto, int): Number of qubits. Can be inferred automatically. 
/// - x (int): Determines at which column the subcircuit will be put in the circuit. 
/// - y (int): Determines at which row the subcircuit will be put in the circuit. 
/// - invert (boolean): If set to `true`, the circuit will be inverted, i.e., a circuit for
///     "uncomputing" the corresponding graph state. 
/// ..edges (array): 
#let graph-state(
  n: auto,
  x: 1,
  y: 0,
  invert: false,
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
/// - n (auto, int): Number of qubits. 
/// - x (int): Determines at which column the QFT routine will be placed in the circuit. 
/// - y (int): Determines at which row the QFT routine will be placed in the circuit. 
#let qft(
  n, 
  x: 1, 
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
