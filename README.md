<h1 align="center">
  <img alt="Quantum Circuit" src="docs/images/logo.svg" style="max-width: 100%; width: 300pt; padding: 10px 20px; box-shadow: 1pt 1pt 10pt 0pt #AAAAAA; border-radius: 4pt">
</h1>


<!-- <p align="center">
  <a href="https://github.com/Mc-Zen/quill/blob/main/LICENSE">
    <img alt="MIT License" src="https://img.shields.io/badge/license-MIT-blue"/>
  </a>
</p> -->

**Quill** is a library for creating quantum circuit diagrams in [Typst](https://typst.app/). 


Note, that this library is still in beta and may still be undergoing breaking changes. As new features like data types and scoped functions will be added to Typst, this library will be adapted to profit from the new paradigms. 

Meanwhile, we suggest importing everything from `quill.typ` in a local scope to avoid polluting the global namespace (see example below). 

<!-- ## Setup

Since there is no package manager for Typst yet, in order to use this library, download the [quill.typ](./qcircuit.typ) file and place it in your Typst project.  -->

## Usage

Create circuit diagrams by calling the function `quantum-circuit()` with any number of positional arguments — just like the built-in Typst functions `table()` or `grid()`. A variety of different gate and instructions commands are available and plain numbers can be used to produce any number of empty cells just filled with the current wire mode. A new wire is started by adding the content item `[\ ]`. 

```java
#{
  import "quill.typ" : *
  quantum-circuit(
    lstick($|0〉$), gate($H$), control(1), rstick($(|00〉+|11〉)/√2$, n: 2), [\ ],
    lstick($|0〉$), 1, targ(), 1
  )
}
```
![Bell circuit example](docs/images/bell.png)

Refer to the [user guide](docs/guide/quill-guide.pdf) for full documentation.

## Gallery

![gallery](docs/images/gallery.svg)

## Examples

Some show-off examples, loosely replicating figures from [Quantum Computation and Quantum Information by M. Nielsen and I. Chuang](https://www.cambridge.org/highereducation/books/quantum-computation-and-quantum-information/01E10196D0A682A6AEFFEA52D53BE9AE#overview).

![phase estimation](tests/references/phase-estimation.png)
![qft](tests/references/qft.png)
![teleportation](tests/references/teleportation.png)

<!-- <img src="tests/references/phase-estimation.png" alt="isolated" width="200"/> -->