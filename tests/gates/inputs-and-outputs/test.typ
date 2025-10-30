#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, mqgate($U$, n: 3, width: 5em,
    inputs: (
      (qubit: 0, n: 2, label: $x$),
      (qubit: 2, label: $y$)
    ),
    outputs: (
      (qubit: 0, n: 2, label: $x$),
      (qubit: 2, label: $y plus.o f(x)$)
    ),
  ), 1, [\ ], 3, [\ ], 3
)