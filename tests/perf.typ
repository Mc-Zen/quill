#import "../src/quill.typ": *


#{
    let arr = ()
    for i in range(1000) {
        arr.push(gate($#i$))
        if calc.rem(i, 10) == 0 { arr.push([\ ]) }
    }
    quantum-circuit(
        1, $H$, 1, ..arr
    )
}