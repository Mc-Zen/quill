#set page(width: auto, height: auto, margin: 0pt)

#{
  import "../quantum-circuit.typ" : *
  quantum-circuit(
    lstick($|0〉$), gate($H$), control(1), rstick($(|00〉+|11〉)/√2$, num-qubits: 2), [\ ],
    lstick($|0〉$), 1, targ(), 1
  )
}