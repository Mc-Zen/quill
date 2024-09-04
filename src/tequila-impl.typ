#import "gates.typ"

#let bgate(qubit, constructor, nq: 1, end: none, ..args) = ((
  qubit: qubit,
  n: nq,
  end: end,
  constructor: constructor,
  args: args
),)

#let generate-single-qubit-gate(qubit, content) = {
  if qubit.named().len() != 0 {
    assert(false, message: "Unexpected argument `" + qubit.named().pairs().first().first() + "`")
  }
  qubit = qubit.pos()
  if qubit.len() == 1 { qubit = qubit.first() }
  if type(qubit) == int { return bgate(qubit, gates.gate, content) }
  qubit.map(qubit => bgate(qubit, gates.gate, content))
}

#let generate-two-qubit-gate(control, target, start, end) = {
  if type(control) == int and type(target) == int { 
    return bgate(control, start, nq: target - control + 1, end: end, target - control) 
  }
  let gates = ()
  if type(control) == int { control = (control,) }
  if type(target) == int { target = (target,) }

  for i in range(calc.max(control.len(), target.len())) {
    let c = control.at(i, default: control.last())
    let t = target.at(i, default: target.last())
    assert.ne(t, c, message: "Target and control qubit cannot be the same")
    gates.push(bgate(c, start, nq: t - c + 1, end: end, t - c) )

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


#let cx(control, target) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.targ
)
#let cz(control, target) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.ctrl.with(0)
)
#let swap(control, target) = generate-two-qubit-gate(
  control, target, gates.swap, gates.swap.with(0)
)


#let ca(control, target, content) = generate-two-qubit-gate(
  control, target, gates.ctrl, gates.gate.with(content)
)


#let build(
  n: auto, 
  ..args
) = {
  let gates = args.pos().flatten()
  let num-qubits = n
  if num-qubits == auto {
    num-qubits = calc.max(..gates.map(x => x.qubit + calc.max(0, x.n - 1))) + 1
  }
  let tracks = ((1,),) * num-qubits
  
  for gate in gates {
    let start = gate.qubit
    // if start < 0 { start = num-qubits + start }
    let end = start + gate.n - 1
    assert(start >= 0 and start < num-qubits, message: "The qubit `" + str(start) + "` is out of range. Leave `n` at `auto` if you want to automatically resize the circuit. ")
    assert(end >= 0 and end < num-qubits, message: "The qubit `" + str(end) + "` is out of range. Leave `n` at `auto` if you want to automatically resize the circuit. ")
    let (q1, q2) = (start, end).sorted()
    if gate.constructor == barrier {
      (q1, q2) = (0, num-qubits - 1)
    }
    let max-track-len = calc.max(..tracks.slice(q1, q2 + 1).map(array.len))
    for q in range(q1, q2 + 1) {
      tracks.at(q) += (1,) * (max-track-len - tracks.at(q).len())
    }
    if gate.constructor != barrier {
      tracks.at(start).push((gate.constructor)(..gate.args))
      if gate.end != none {
        tracks.at(end).push((gate.end)())
      }
    }
  }
  
  let max-track-len = calc.max(..tracks.map(array.len)) + 1
  for q in range(tracks.len()) {
    tracks.at(q) += (1,) * (max-track-len - tracks.at(q).len())
  }
  tracks.join(([\ ],))
}




#let graph-state(..edges, n: auto) = {
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
  build(
    h(range(num-qubits)),
    edges.map(edge => cz(..edge))
  )
}


#let qft(n) = {
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
  build(n: n, ..gates)
}
