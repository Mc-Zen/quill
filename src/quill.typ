#import "utility.typ"
#import "length-helpers.typ"
#import "decorations.typ": *
#import "quantum-circuit.typ": quantum-circuit


#let help(..args) = {
  import "@preview/tidy:0.3.0"

  let namespace = (
    ".": (
      read.with("/src/quantum-circuit.typ"), 
      read.with("/src/gates.typ"),
      read.with("/src/decorations.typ"),
    ),
    "gates": read.with("/src/gates.typ"),
  )
  tidy.generate-help(namespace: namespace, package-name: "quill")(..args)
}