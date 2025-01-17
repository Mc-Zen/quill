#import "template.typ": *
#import "@preview/tidy:0.4.0"


#let version = toml("/typst.toml").package.version
#show link: set text(fill: rgb("#1e8f6f"))

#show: project.with(
  title: "Quill",
  authors: ("Mc-Zen",),
  abstract: [Quill is a library for creating quantum circuit diagrams in #link("https://typst.app/", [Typst]). ],
  date: datetime.today().display("[month repr:long] [day], [year]"),
  version: version,
  url: "https://github.com/Mc-Zen/quill"
)

#v(4em)

#outline(depth: 2, indent: 2em)
#pagebreak()

= Introduction

#pad(x: 1cm)[_@gate-gallery features a gallery of many gates and symbols and how to create them. In @demo, you can find a variety of example figures along with the code. @tequila introduces an alternative model for creating and composing circuits._]

Would you like to create quantum circuits directly in Typst? Maybe a circuit for quantum teleportation?
#figure[#include("../../examples/teleportation.typ")]

Or one for phase estimation? The code for both examples can be found in @demo.
#figure[#include("../../examples/phase-estimation.typ")]

This library provides high-level functionality for generating these and more quantum circuit diagrams. 

For those who work with the LaTeX packages `qcircuit` and `quantikz`, the syntax will be familiar. The wonderful thing about Typst is that the changes can be viewed instantaneously which makes it ever so much easier to design a beautiful quantum circuit. The syntax also has been updated a little bit to fit with concepts of the Typst language and many things like styling content is much simpler than with `quantikz` since it is directly supported in Typst. 


= Basics

A circuit can be created by calling the #ref-fn("quantum-circuit()") function with a number of circuit elements.


// #example(
// ```typ
// #quantum-circuit(
//   lstick($|0〉$), gate($H$), phase($ϑ$), 
//   gate($H$), rstick($cos ϑ/2 lr(|0〉)-sin ϑ/2 lr(|1〉)$)
// )
// ```)


#example(
  ```typ
  #quantum-circuit(
    1, gate($H$), phase($theta.alt$), meter(), 1
  )
  ```
)

A quantum gate is created with the #ref-fn("gate()") command.  To make life easier, instead of calling `gate($H$)`, you can also just put in the gate's content `$H$`. Unlike `qcircuit` and `quantikz`, the math environment is not automatically entered for the content of the gate which allows for passing in any type of content (even images or tables). Use displaystyle math (for example `$ U_1 $` instead of `$U_1$` to enable appropriate scaling of the gate for more complex mathematical expressions like double subscripts etc. 

#pagebreak()

Consecutive gates are automatically joined with wires. Plain integers can be used to indicate a number of cells with just wire and no gate (where you would use a lot of `&`'s and `\qw`'s in `quantikz`). 

#example(
  ```typ
  #quantum-circuit(
    1, $H$, 4, meter()
  )
  ```
)



A new wire can be created by breaking the current wire with `[\ ]`:

#example(
  ```typ
  #quantum-circuit(
    1, $H$, ctrl(1), 1, [\ ],
    2, targ(), 1
  )
  ```
)

We can create a #smallcaps("cx")-gate by calling #ref-fn("ctrl()") and passing the relative distance to the desired wire, e.g., `1` to the next wire, `2` to the second-next one or `-1` to the previous wire. Per default, the end of the vertical wire is  just joined with the target wire without any decoration at all. Here, we make the gate a #smallcaps("cx")-gate by adding a #ref-fn("targ()") symbol on the second wire. In order to make a #smallcaps("cz")-gate with another control circle on the target wire, just use `ctrl(0)` as target. 


== Multi-Qubit Gates and Wire Labels
Let's look at a quantum bit-flipping error correction circuit. Here we encounter our first multi-qubit gate as well as wire labels:

#example(vertical: true,
  ```typ
  #quantum-circuit(
    lstick($|psi〉$), ctrl(1), ctrl(2), mqgate($E_"bit"$, n: 3), ctrl(1), ctrl(2), 
      targ(), rstick($|psi〉$), [\ ],
    lstick($|0〉$), targ(), 2, targ(), 1, ctrl(-1), 1, [\ ],
    lstick($|0〉$), 1, targ(), 2, targ(), ctrl(-1), 1
  )
  ```
)

Multi-qubit gates have a dedicated command #ref-fn("mqgate()") which allows to specify the number of qubits `n` as well as a variety of other options. Wires can be labelled at the beginning or the end with the #ref-fn("lstick()") and #ref-fn("rstick()") commands, respectively. Both create a label "sticking" out from the wire. 

#pagebreak()

Just as multi-qubit gates, #ref-fn("lstick()") and #ref-fn("rstick()") can span multiple wires, again with the parameter `n`. Furthermore, the brace can be changed or turned off with `brace: none`. If the label is only applied to a single qubit, it will have no brace by default but in this case a brace can be added just the same way. By default it is set to `brace: auto`.

#example(vertical: true,
  ```typ
  #quantum-circuit(
    lstick($|000〉$, n: 3), $H$, ctrl(1), ctrl(2), 1,
      rstick($|psi〉$, n: 3, brace: "]"), [\ ],
    1, $H$, ctrl(0), 3, [\ ],
    1, $H$, 1, ctrl(0), 2
  )
  ```
)


== All about Wires
In many circuits, we need classical wires. This library generalizes the concept of quantum, classical and bundled wires and provides the #ref-fn("setwire()") command that allows all sorts of changes to the current wire setting. You may call `setwire()` with the number of wires to display and optionally a `stroke` setting:

#example(vertical: false,
  ```typ
  #quantum-circuit(
    1, $A$, meter(n: 1), [\ ],
    setwire(2, stroke: blue), 2, ctrl(0), 2, [\ ],
    1, $X$, setwire(0), 1, lstick($|0〉$), setwire(1), $Y$,
  )
  ```
)

The `setwire()` command produces no cells and can be called at any point on the wire. When a new wire is started, the default wire setting is restored automatically (see @circuit-styling on how to customize the default). Calling `setwire(0)` removes the wire altogether until `setwire()` is called with different arguments. More than two wires are possible and it lies in your hands to decide how many wires still look good. The distance between bundled wires can also be specified:

#example(vertical: false,
  ```typ
  #quantum-circuit(
    setwire(4, wire-distance: 1.5pt), 1, $U$, meter()
  )
  ```
)


#pagebreak()

== Slices and Gate Groups

In order to structure quantum circuits, you often want to mark sections to denote certain steps in the circuit. This can be easily achieved through the #ref-fn("slice()") and #ref-fn("gategroup()") commands. Both are inserted into the circuit where the slice or group should begin and allow an arbitrary number of labels through the `labels` argument (more on labels in @labels). The function `gategroup()` takes two positional integer arguments which specify the number of wires and steps the group should span. Slices reach down to the last wire by default but the number of sliced wires can also be set manually. 


#example(
  ```typ
  #quantum-circuit(
    1, gate($H$), ctrl(1), 
      slice(label: "1"), 1,
      gategroup(3, 3, label: (content:
      "Syndrome measurement", pos: bottom)),
      1, ctrl(2), ctrl(0), 1,
      slice(label: "3", n: 2,
        stroke: blue), 
      2, [\ ],
    2, targ(), 1, ctrl(1), 1, ctrl(0), 3, [\ ], 
    4, targ(), targ(), meter(target: -2)
  )
  ```
)

== Labels <labels>
Finally, we want to show how to place labels on gates and vertical wires. The function #ref-fn("gate()") and all the derived gate commands such as #ref-fn("meter()"), #ref-fn("ctrl()"), #ref-fn("lstick()") etc. feature a `label` argument for adding any number of labels on and around the element. In order to produce a simple label on the default position (for plain gates this is at the top of the gate, for vertical wires it is to the right and for the #ref-fn("phase()") gate it is to the top right), you can just pass content or a string:

#example(
  ```typ
  #quantum-circuit(
    1, gate($H$, label: "Hadamard"), 1
  )
  ```
)

If you want to change the position of the label or specify the offset, you want to pass a dictionary with the key `content` and optional values for `pos` (alignment), `dx` and `dy` (length, ratio or relative length):

#example(
```typ
  #quantum-circuit(
    1, gate($H$, label: (content: "Hadamard", pos: bottom, dy: 0pt)), 1
  )
  ```
)

#pagebreak()

Multiple labels can be added by passing an array of labels specified through dictionaries. 

#example(
  ```typ
  #quantum-circuit(
    1, gate(hide($H$), label: (
      (content: "lt", pos: left + top),
      (content: "t", pos: top),
      (content: "rt", pos: right + top),
      (content: "l", pos: left),
      (content: "c", pos: center),
      (content: "r", pos: right),
      (content: "lb", pos: left + bottom),
      (content: "b", pos: bottom),
      (content: "rb", pos: right + bottom),
    )), 1
  )
  ```
)

Labels for slices and gate groups work just the same. In order to place a label on a control wire, you can use the `wire-label` parameter provided for #ref-fn("mqgate()"), #ref-fn("ctrl()") and #ref-fn("swap()").

#example(
  ```typ
  #quantum-circuit(
    1, ctrl(1, wire-label: $phi$), 2,
      swap(1, wire-label: (
        content: rotate(-90deg, smallcaps("swap")), 
        pos: left, dx: 0pt)
      ), 1, [\ ], 10pt,
    1, ctrl(0), 2, swap(0), 1,
  )
  ```
)



#pagebreak()
= Gate Placement <gate-placement>
By default, all gates are placed automatically and sequentially. In this, `quantum-circuit()` behaves similar to the built-in `table()` and `grid()` functions. However, just like with `table.cell` and `grid.cell`, it is also possible to place any gate at a certain column `x` and row `y`. This makes it possible to simplify redundant code. 

Let's look at an example of preparing a certain graph state:

#example(
  ```typ
  #quantum-circuit(
    ..range(4).map(i => lstick($|0〉$, y: i, x: 0)),
    ..range(4).map(i => gate($H$, y: i, x: 1)),
    2,
    ctrl(2), 1, ctrl(1), 1, [\ ],
    3, ctrl(2), ctrl(0), [\ ],
    2, ctrl(0), [\ ],
    3, ctrl(0)
  )
  ```
)
Note, that it is not possible to add a second gate to a cell that is already occupied. However, it is allowed to leave either `x` or `y` at `auto` and manually set the other. In the case that `x` is set but `y: auto`, the gate is placed at the current wire and the specified column. In the case that `y` is set and `x: auto`, the gate is placed at the current column and the specified wire but the current column is not advanced to the next column. The parameters `x` and `y` are available for all gates and decorations. 

Manual placement can also be helpful to keep the source code a bit more cleaner. For example, it is possible to move the code for a `gategroup()` or `slice()` command entirely to the bottom to enhance readability. 

#example(text-size: .9em,
  ```typ
  #quantum-circuit(
    1, $S^dagger$, $H$, ctrl(0), $H$, $S$, 1, [\ ],
    3, ctrl(-1),
    gategroup(2, 5, x: 1, y: 0, stroke: purple, 
      label: (pos: bottom, content: text(purple)[CY gate])),
    gategroup(2, 3, x: 2, y: 0, stroke: blue, 
      label: text(blue)[CX gate]),
  )
  ```
)


#pagebreak()
= Circuit Styling <circuit-styling>

The #ref-fn("quantum-circuit()") command provides several options for styling the entire circuit. The parameters `row-spacing` and `column-spacing` allow changing the optical density of the circuit by adjusting the spacing between circuit elements vertically and horizontically. 

#example(
  ```typ
  #quantum-circuit(
    row-spacing: 5pt,
    column-spacing: 5pt,
    1, $A$, $B$, 1, [\ ],
    1, 1, $S$, 1
  )
  ```
)

The `wire`, `color` and `fill` options provide means to customize line strokes and colors. This allows us to easily create "dark-mode" circuits:

#example(
  ```typ
  #box(fill: black, quantum-circuit(
    wire: .7pt + white, // Wire and stroke color
    color: white,       // Default foreground and text color
    fill: black,        // Gate fill color
    1, $X$, ctrl(1), rstick([*?*]), [\ ],
    1,1, targ(), meter(), 
  ))
  ```
)

Furthermore, a common task is changing the total size of a circuit by scaling it up or down. Instead of tweaking all the parameters like `font-size`, `padding`, `row-spacing` etc. you can specify the `scale` option which takes a percentage value:

#example(
  ```typ
  #quantum-circuit(
    scale: 60%,
    1, $H$, ctrl(1), $H$, 1, [\ ],
    1, 1, targ(), 2
  )
  ```
)

Note, that this is different than calling Typst's built-in `scale()` function on the circuit which would scale it without affecting the layout, thus still reserving the same space as if unscaled!

#pagebreak()

For an optimally layout, the height for each row is determined by the gates on that wire. For this reason, the wires can have different distances. To better see the effect, let's decrease the `row-spacing`:

#example(
  ```typ
  #quantum-circuit(
      row-spacing: 2pt, min-row-height: 4pt,
      1, $H$, ctrl(1), $H$, 1, [\ ],
      1, $H$, targ(), $H$, 1, [\ ],
      2, ctrl(1), 2, [\ ],
      1, $H$, targ(), $H$, 1
  )
  ```
)

Setting the option `equal-row-heights` to `true` solves this problem (manually spacing the wires with lengths is still possible, see @fine-tuning):

#example(
  ```typ
  #quantum-circuit(
      equal-row-heights: true,
      row-spacing: 2pt, min-row-height: 4pt,
      1, $H$, ctrl(1), $H$, 1, [\ ],
      1, $H$, targ(), $H$, 1, [\ ],
      2, ctrl(1), 2, [\ ],
      1, $H$, targ(), $H$, 1
  )
  ```
)

// #example(
// ```typ
// #quantum-circuit(
//   scale: 60%,
//   1, gate($H$), ctrl(1), gate($H$), 1, [\ ],
//   1, 1, targ(), 2
// )
// ```, [
//   #quantum-circuit(
//     baseline: "=",
//     2, ctrl(1), 2, [\ ],
//     1, gate($H$), targ(), gate($H$), 1
//   ) =
//   #quantum-circuit(
//     baseline: "=",
//     phantom(), ctrl(1),  1, [\ ],
//      phantom(content: $H$), ctrl(0), phantom(content: $H$),
//   )
// ])


There is another option for #ref-fn("quantum-circuit()") that has a lot of impact on the looks of the diagram: `gate-padding`. This at the same time controls the default gate box padding and the distance of `lstick`s and `rstick`s to the wire. Need really wide or tight circuits?

#example(
  ```typ
  #quantum-circuit(
      gate-padding: 2pt,
      row-spacing: 5pt, column-spacing: 7pt,
      lstick($|0〉$, n: 3), $H$, ctrl(1), 
        ctrl(2), 1, rstick("GHZ", n: 3), [\ ],
      1, $H$, ctrl(0), 1, $H$, 1, [\ ],
      1, $H$, 1, ctrl(0), $H$, 1
  )
  ```
)


#pagebreak()

= Gate Gallery <gate-gallery>


#[
  #set par(justify: false)
  #import "gallery.typ": gallery
  #gallery
]
#pagebreak()



= Fine-Tuning <fine-tuning>

The #ref-fn("quantum-circuit()") command allows not only gates as well as content and string items but only `length` parameters which can be used to tweak the spacing of the circuit. Inserting a `length` value between two gates adds a *horizontal space* of that length between the cells:

#example(
  ```typ
  #quantum-circuit(
    $X$, $Y$, 10pt, $Z$
  )
```
)

In the background, this works like a grid gutter that is set to `0pt` by default. If a length value is inserted between the same two columns on different wires/rows, the maximum value is used for the space. In the same spirit, inserting multiple consecutive length values result in the largest being used, e.g., inserting `5pt, 10pt, 6pt` results in a `10pt` gutter in the corresponding position. 

Putting a a length after a wire break item `[\ ]` produces a *vertical space* between the corresponding wires:

#example(
  ```typ
  #quantum-circuit(
    $X$, [\ ], $Y$, [\ ], 10pt, $Z$
  )
  ```
)





#pagebreak()

= Annotations

*Quill* provides a way of making custom annotations through the #ref-fn("annotate()") interface. An `annotate()` object may be placed anywhere in the circuit, the position only matters for the draw order in case several annotations would overlap. 


The `annotate()` command allows for querying cell coordinates of the circuit and passing in a custom draw function to draw globally in the circuit diagram. // This way, basically any decoration

Let's look at an example:

#example(
  ```typ
  #quantum-circuit(
    1, ctrl(1), $H$, meter(), [\ ],
    1, targ(), 1, meter(),
    annotate((2, 4), 0, ((x1, x2), y) => { 
        let brace = math.lr($#block(height: x2 - x1)}$)
        place(dx: x1, dy: y, rotate(brace, -90deg, origin: top))
        let content = [Readout circuit]
        context {
          let size = measure(content)
          place(
            dx: x1 + (x2 - x1) / 2 - size.width / 2,
            dy: y - .6em - size.height, content
          )
        }
    })
  )
  ```
)

First, the call to `annotate()` asks for the $x$ coordinates of the second and forth column and the $y$ coordinate of the zeroth row (first wire). The draw callback function then gets the corresponding coordinates as arguments and uses them to draw a brace and some text above the cells. Optionally, you can specify whether the annotation should be drawn above or below the circuit by adding `z: above` or `z: "below"`. The default is `"below"`. 

Note, that the circuit does not know how large the annotation is by default. For this reason, the annotation may exceed the bounds of the circuit. This can be fixed by letting the callback return a dictionary with the keys `content`, `dx` and `dy` (the latter two are optional). The content should be measurable, i.e., not be wrapped in a call to `place()`. Instead the placing coordinates can be specified via the keys `dx` and `dy`. 

Another example, here we want to obtain coordinates for the cell centers. We can achieve this by adding $0.5$ to the cell index. The fractional part of the number represents a percentage of the cell width/height. 

#example(
  ```typ
  #quantum-circuit(
    1, $X$, 2, [\ ],
    1, 2, $Y$, [\ ],
    1, 1, $H$, meter(), 
    annotate((1.5, 3.5, 2.5), (0.5, 1.5, 2.5), z: "above",
      ((x0, x1, x2), (y0, y1, y2)) => { 
        (
          content: path(
            (x0, y0), (x1, y1), (x2, y2), 
            closed: true, 
            fill: rgb("#1020EE50"), stroke: .5pt + black
          ), 
        )
    })
  )
```
)


#pagebreak()
= Custom Gates

Quill allows you to create totally customized gates by specifying the `draw-function` argument in #ref-fn("gate()") or #ref-fn("mqgate()"). You will not need to do this however if you just want to change the color of the gate or make it round. For these tasks you can just use the appropriate arguments of the #ref-fn("gate()") command. 

_Note, that the interface for custom gates might still change a bit. _

When the circuit is laid out, the draw function is called with two (read-only) arguments: the gate itself and a dictionary that contains information about the circuit style and more. 

Let us look at a little example for a custom gate that just shows the vertical lines of the box but not the horizontal ones. 

#let quill-gate = ```typ
  #let draw-quill-gate(gate, draw-params) = {
    let stroke = draw-params.wire
    let fill = if gate.fill != none { gate.fill } else { draw-params.background }

    box(
      gate.content, 
      fill: fill, stroke: (left: stroke, right: stroke), 
      inset: draw-params.padding
    )
  }
  ```
#box(inset: 1em, quill-gate)

We can now use it like this:

#example(scope: (draw-quill-gate: (gate, draw-params) => {
    let stroke = draw-params.wire
    let fill = if gate.fill != auto { gate.fill } else { draw-params.background }

    box(
      gate.content, 
      fill: fill, stroke: (left: stroke, right: stroke), 
      inset: draw-params.padding
    )
  }),
  ```typ
  #quantum-circuit(
    1, gate("Quill", draw-function: draw-quill-gate), 1,
  )
  ```
)


The first argument for the draw function contains information about the gate. From that we read the gate's `content` (here `"Quill"`). We create a `box()` with the content and only specify the left and right edge stroke. In order for the circuit to look consistent, we read the circuit style from the draw-params. The key `draw-params.wire` contains the (per-circuit) global wire stroke setting as set through `quantum-circuit(wire: ...)`. Additionally, if a fill color has been specified for the gate, we want to use it. Otherwise, we use `draw-params.background` to be conform with for example dark-mode circuits. Finally, to create space, we add some inset to the box. The key `draw-params.padding` holds the (per-circuit) global gate padding length. 

It is generally possible to read any value from a gate that has been provided in the gate's constructor. Currently, `content`, `fill`, `radius`, `width`, `box` and `data` (containing the optional data argument that can be added in the #ref-fn("gate()") function) can be read from the gate. For multi-qubit gates, the key `multi` contains a dictionary with the keys `target` (specifying the relative target qubit for control wires), `num-qubits`, `wire-count` (the wire count for the control wire) and `extent` (the amount of length to extend above the first and below the last wire). 

All built-in gates are drawn with a dedicated `draw-function` and you can also take a look at the source code for ideas and hints. 


#pagebreak()
= Function Documentation

#[
  
  #set text(size: 9pt)
  
  #show raw.where(block: false, lang: "typc"): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  
  
  #show heading: set text(size: 1.2em)
  #show heading.where(level: 3): it => { align(center, it) }
  
  #columns(1,[      
    This section contains a complete reference for every function in *quill*. 
    
    // #set raw(lang: none)
    #set heading(numbering: none)
    #{
            
      let my-show-example = tidy.show-example.show-example.with(
        layout: (code, preview) => pad(x: 15em, grid(
          columns: (2fr, auto), 
          align: horizon, 
          code, 
          preview
        ))
      )
    
      let parse-module = tidy.parse-module.with(
        label-prefix: "quill:",
        scope: dictionary(quill),
        old-syntax: false
      )
      let show-module = tidy.show-module.with(
        show-module-name: false, 
        first-heading-level: 2,
        show-outline: false,
        style: dictionary(tidy.styles.default) + (show-example: my-show-example),
        sort-functions: none
      )
      


      let show-outline = tidy.styles.default.show-outline.with(style-args: (enable-cross-references: true))
      
      let docs = parse-module(read("/src/quantum-circuit.typ"))
      let docs-gates = parse-module(read("/src/gates.typ"))
      let docs-decorations = parse-module(read("/src/decorations.typ"))
    
      [*Quantum Circuit*]
      show-outline(docs)
      [*Gates*]
      show-outline(docs-gates)
      [*Decorations*]
      show-outline(docs-decorations)

      set text(size: .9em)

      show-module(docs)
      v(1cm)
      show-module(docs-gates)
      v(1cm)
      show-module(docs-decorations)

      let docs-tequila = parse-module(read("/src/tequila-impl.typ"))

      colbreak()

      heading(outlined: false)[Tequila]
      v(2mm)
      show-outline(docs-tequila)
      show-module(docs-tequila)

    }
  ])

]


#pagebreak()
= Demo <demo>

#show raw.where(block: true): set text(size: 0.9em)


This section demonstrates the use of the *quantum-circuit* library by reproducing some figures from the famous book _Quantum Computation and Quantum Information_ by Nielsen and Chuang @nielsen_2022_quantum.

== Quantum Teleportation
Quantum teleportation circuit reproducing the Figure 4.15 in @nielsen_2022_quantum. 
#insert-example("../../examples/teleportation.typ")


== Quantum Phase Estimation
Quantum phase estimation circuit reproducing the Figure 5.2 in @nielsen_2022_quantum. 
#insert-example("../../examples/phase-estimation.typ")

#pagebreak()


== Quantum Fourier Transform:
Circuit for performing the quantum Fourier transform, reproducing the Figure 5.1 in @nielsen_2022_quantum. 
#insert-example("../../examples/qft.typ")


== Shor Nine Qubit Code

Encoding circuit for the Shor nine qubit code. This diagram reproduces Figure 10.4 in @nielsen_2022_quantum

#table(columns: (2fr, 1fr), align: horizon, stroke: none,
  block(raw({
    let content = read("/examples/shor-nine-qubit-code.typ")
    content.slice(content.position("*")+1).trim()}, lang: "typ"), fill: gray.lighten(90%), inset: .8em), 
  include("/examples/shor-nine-qubit-code.typ")
)

#pagebreak()


== Fault-Tolerant Measurement

Circuit for performing fault-tolerant measurement (as Figure 10.28 in @nielsen_2022_quantum). 
#insert-example("../../examples/fault-tolerant-measurement.typ")


== Fault-Tolerant Gate Construction
The following two circuits reproduce figures from Exercise 10.66 and 10.68 on construction fault-tolerant $pi/8$ and Toffoli gates in @nielsen_2022_quantum.
#insert-example("../../examples/fault-tolerant-pi8.typ")
#insert-example("../../examples/fault-tolerant-toffoli1.typ")
#insert-example("../../examples/fault-tolerant-toffoli2.typ")


#pagebreak()



= Tequila <tequila>

_Tequila_ is a submodule of *Quill* that adds a completely different way of building circuits. 

#example(
```typ
#import tequila as tq

#quantum-circuit(
  ..tq.build(
    tq.h(0),
    tq.cx(0, 1),
    tq.cx(0, 2),
  ),
)
```
)
This is similar to how _QASM_ and _Qiskit_ work: gates are successively applied to the circuit which is then layed out automatically by packing gates as tightly as possible. We start by calling the `tq.build()` function and filling it with quantum operations. This returns a collection of gates which we expand into the circuit with the `..` syntax. 
Now, we still have the option to add annotations, groups, slices, or even more gates via manual placement. 

The syntax works analog to Qiskit. Available gates are `x`, `y`, `z`, `h`, `s`, `sdg`, `sx`, `sxdg`, `t`, `tdg`, `p`, `rx`, `ry`, `rz`, `u`, `cx`, `cz`, and `swap`. With `barrier`, an invisible barrier can be inserted to prevent gates on different qubits to be packed tightly. Finally, with `tq.gate` and `tq.mqgate`, a generic gate can be created. These two accept the same styling arguments as the normal `gate` (or `mqgate`).

Also like Qiskit, all qubit arguments support ranges, e.g., `tq.h(range(5))` adds a Hadamard gate on the first five qubits and `tq.cx((0, 1), (1, 2))` adds two #smallcaps[cx] gates: one from qubit 0 to 1 and one from qubit 1 to 2. 

With Tequila, it is easy to build templates for quantum circuits and to compose circuits of various building blocks. For this purpose, `tq.build()` and the built-in templates all feature optional `x` and `y` arguments to allow placing a subcircuit at an arbitrary position of the circuit. 
As an example, Tequila provides a `tq.graph-state()` template for quickly drawing graph state preparation circuits. 

The following example demonstrates how to compose multiple subcircuits. 

#example(scale: 74%,
```typ
#import tequila as tq

#quantum-circuit(
  ..tq.graph-state((0, 1), (1, 2)),
  ..tq.build(y: 3, 
      tq.p($pi$, 0), 
      tq.cx(0, (1, 2)), 
    ),
  ..tq.graph-state(x: 6, y: 2, invert: true, (0, 1), (0, 2)),
  gategroup(x: 1, 3, 3),
  gategroup(x: 1, y: 3, 3, 3),
  gategroup(x: 6, y: 2, 3, 3),
  slice(x: 5)
)
```
)

#block(breakable: false)[
To demonstrate the creation of templates, we give the (simplified) implementation of `tq.graph-state()` in the following:

#example(
```typ
#let graph-state(..edges, x: 1, y: 0) = tq.build(
  x: x, y: y,
  tq.h(range(num-qubits)),
  edges.map(edge => tq.cz(..edge))
)
```
)
]

// This makes it easier to generate certain classes of circuits, for example in order to have a good starting point for a more complex circuit. 

Another built-in building block is `tq.qft(n)` for inserting a quantum fourier transform (QFT) on $n$ qubits. 

#example(scale: 80%,
```typ
#quantum-circuit(..tequila.qft(y: 1, 4))
```
)



#bibliography("references.bib")
