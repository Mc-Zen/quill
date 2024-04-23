#import "utility.typ"
#import "length-helpers.typ"
#import "decorations.typ": *

#let signum(x) = if x >= 0. { 1. } else { -1. }


#let quantum-circuit(
  wire: .7pt + black,     
  row-spacing: 12pt,
  column-spacing: 12pt,
  min-row-height: 10pt, 
  min-column-width: 0pt, 
  gate-padding: .4em, 
  equal-row-heights: false, 
  color: black,
  fill: white,
  font-size: 10pt,
  scale: 100%,
  scale-factor: 100%,
  baseline: 0pt,
  circuit-padding: .4em,
  ..children
) = { 
  if children.pos().len() == 0 { return }
  if children.named().len() > 0 { 
    panic("Unexpected named argument '" + children.named().keys().at(0) + "' for quantum-circuit()")
  }
  set text(color, size: font-size)
  set math.equation(numbering: none)

  style(styles => {
  
  // Parameter object to pass to draw-function containing current style info
  let draw-params = (
    wire: wire,
    padding: measure(line(length: gate-padding), styles).width,
    background: fill,
    color: color,
    styles: styles,
    x-gate-size: none,
    multi: (wire-distance: 0pt),
    em: measure(line(length: 1em), styles).width
  )

  draw-params.x-gate-size = layout.default-size-hint(gate($X$), draw-params)
  
  let items = children.pos().map( x => {
    if type(x) in ("content", "string") and x != [\ ] { return gate(x) }
    return x
  })
  
  /////////// First part: Layout (and spacing)   ///////////
  
  let column-spacing = length-helpers.convert-em-length(column-spacing, draw-params.em)
  let row-spacing = length-helpers.convert-em-length(row-spacing, draw-params.em)
  let min-row-height = length-helpers.convert-em-length(min-row-height, draw-params.em)
  let min-column-width = length-helpers.convert-em-length(min-column-width, draw-params.em)
  
  // All these arrays are gonna be filled up in the loop over `items`
  let matrix = ((),)
  let row-gutter = (0pt,)
  let gates = ()
  let mqgates = ()
  let meta-instructions = ()

  let auto-cell = (empty: true, size: (width: 0pt, height: 0pt), gutter: 0pt)

  let default-wire-style = (
    count: 1,
    distance: 1pt, 
    stroke: wire
  )
  let wire-style = default-wire-style
  let wire-instructions = ()

  let (row, col) = (0, 0)
  let prev-col = 0
  let wire-ended = false

  for item in items {
    if item == [\ ] {
      row += 1; col = 0; prev-col = 0

      if row >= matrix.len() {
        matrix.push(())
        row-gutter.push(0pt)
      }
      wire-style = default-wire-style
      wire-instructions.push(wire-style)
      wire-ended = true
    } else if utility.is-circuit-meta-instruction(item) { 
      if item.qc-instr == "setwire" {
        wire-style.count = item.wire-count
        wire-style.distance = item.wire-distance
        if item.stroke != none { wire-style.stroke = item.stroke }
        wire-instructions.push(wire-style)
      } else {
        // Visual meta instructions are handled later
        let (x, y) = (item.x, item.y)
        if x == auto { x = col }
        if y == auto { y = row }
        meta-instructions.push((x: x, y: y, item: item))
      }
    } else if utility.is-circuit-drawable(item) {
      let gate = item
      let (x, y) = (gate.x, gate.y)
      if x == auto { 
        x = col 
        if col != prev-col {
          wire-instructions.push((row, prev-col, col))
        }
        prev-col = col 
        col += 1
      }
      if y == auto { y = row }

      if y >= matrix.len() { matrix += ((),) * (y - matrix.len() + 1) }
      if x >= matrix.at(y).len() {
        matrix.at(y) += (auto-cell,) * (x - matrix.at(y).len() + 1)
      }

      assert(matrix.at(y).at(x).empty, message: "Attempted to place a second gate at column " + str(x) + ", row " + str(y))

      let size-hint = utility.get-size-hint(item, draw-params)
      let gate-size = size-hint
      if item.floating { size-hint.width = 0pt } // floating items don't take width in the layout

      matrix.at(y).at(x) = (
        size: size-hint,
        gutter: 0pt,
        box: item.box,
        empty: false
      )
      let gate-info = (
        gate: gate,
        size: gate-size,
        x: x,
        y: y
      )
      if gate.multi != none { mqgates.push(gate-info) } 
      else { gates.push(gate-info) }
      wire-ended = false
    } else if type(item) == int {
      wire-instructions.push((row, prev-col, col + item - 1))
      col += item
      prev-col = col - 1
      if col >= matrix.at(row).len() {
        matrix.at(row) += (auto-cell,) * (col - matrix.at(row).len())
      }
      wire-ended = false
    } else if type(item) == length {
      if wire-ended {
        row-gutter.at(row - 1) = calc.max(row-gutter.at(row - 1), item)
      } else if col > 0 {
        matrix.at(row).at(col - 1).gutter = calc.max(matrix.at(row).at(col - 1).gutter, item)
      }
    }
  }


  // finish up matrix
  let num-rows = matrix.len()
  let num-cols = calc.max(0, ..matrix.map(array.len))
  if num-rows == 0 or num-cols == 0 { return none }
  for i in range(num-rows) {
    matrix.at(i) += (auto-cell,) * (num-cols - matrix.at(i).len())
  }
  row-gutter += (0pt,) * (matrix.len() - row-gutter.len())

  let vertical-wires = ()
  // Treat multi-qubit gates (and controlled gates)
  for mqgate in mqgates {
    let (x, y) = mqgate
    let size = matrix.at(y).at(x).size
    let multi = mqgate.gate.multi
    
    if multi.target != none and multi.target != 0 {
      assert(y + multi.target < num-rows, message: "A controlled gate starting at qubit " + str(y) + " with relative target " + str(multi.target) + " exceeds the circuit which has only " + str(num-rows) + " qubits")
      let diff = if multi.target > 0 {multi.num-qubits - 1} else {0}
      vertical-wires.push((
        x: x, 
        y: y + diff, 
        target: multi.target - diff, 
        wire-style: (count: multi.wire-count),
        labels: multi.wire-label
      ))
    }
    let nq = multi.num-qubits
    if nq == 1 { continue }
    assert(y + nq - 1 < num-rows, message: "A " + str(nq) + "-qubit gate starting at qubit " + str(y) + " exceeds the circuit which has only " + str(num-rows) + " qubits")
    for qubit in range(y, y + nq) {
      matrix.at(qubit).at(x).size.width = size.width
    }
    let start = y
    if multi.size-all-wires != none {
      if not multi.size-all-wires {
        start = calc.max(0, y + nq - 1)
      }
      for qubit in range(start, y + nq) {
        matrix.at(qubit).at(x).size = size
      }
    }
  }


  let rowheights = matrix.map(row => 
    calc.max(min-row-height, ..row.map(item => item.size.height)) + row-spacing
  )
  if equal-row-heights {
    let max-row-height = calc.max(..rowheights)
    rowheights = (max-row-height,) * rowheights.len()
  }

  let colwidths = range(num-cols).map(j => 
    calc.max(min-column-width, ..range(num-rows).map(i => {
        matrix.at(i).at(j).size.width
    })) + column-spacing 
  )

  let col-gutter = range(num-cols).map(j => 
    calc.max(0pt, ..range(num-rows).map(i => {
        matrix.at(i).at(j).gutter
    }))
  )

  let center-x-coords = layout.compute-center-coords(colwidths, col-gutter).map(x => x - 0.5 * column-spacing)
  let center-y-coords = layout.compute-center-coords(rowheights, row-gutter).map(x => x - 0.5 * row-spacing)
  draw-params.center-y-coords = center-y-coords
  
  let circuit-width = colwidths.sum() + col-gutter.slice(0, -1).sum(default: 0pt) - column-spacing
  let circuit-height = rowheights.sum() + row-gutter.sum() - row-spacing




  let get-gate-pos(x, y, size-hint) = {
    let dx = center-x-coords.at(x)
    let dy = center-y-coords.at(y)
    let (width, height) = size-hint
    let offset = size-hint.at("offset", default: auto)

    if offset == auto { return (dx - width / 2, dy - height / 2) } 

    assert(type(offset) == "dictionary", message: "Unexpected type `" + type(offset) + "` for parameter `offset`") 
    
    let offset-x = offset.at("x", default: auto)
    let offset-y = offset.at("y", default: auto)
    if offset-x == auto { dx -= width / 2}
    else if type(offset-x) == "length" { dx -= offset-x }
    if offset-y == auto { dy -= height / 2}
    else if type(offset-y) == "length" { dy -= offset-y }
    return (dx, dy)
  }


  /////////// Second part: Generation ///////////
  
  let bounds = (0pt, 0pt, circuit-width, circuit-height)
  
  let circuit = block(
    width: circuit-width, height: circuit-height, {
    set align(top + left) // quantum-circuit could be called in a scope where these have been changed which would mess up everything


    for (item, x, y) in meta-instructions {
      if item.qc-instr == "gategroup" {
        assert(item.wires > 0, message: "gategroup: wires arg needs to be > 0")
        assert(y+item.wires <= rowheights.len(), message: "gategroup: height exceeds range")
        assert(item.steps > 0, message: "gategroup: steps arg needs to be > 0")
        assert(x+item.steps <= colwidths.len(), message: "gategroup: width exceeds range")
        let y1 = layout.get-cell-coords(center-y-coords, rowheights, y)
        let y2 = layout.get-cell-coords(center-y-coords, rowheights, y + item.wires - 1e-9)
        let x1 = layout.get-cell-coords(center-x-coords, colwidths, x)
        let x2 = layout.get-cell-coords(center-x-coords, colwidths, x + item.steps - 1e-9)
        let (result, b) = draw-functions.draw-gategroup(x1, x2, y1, y2, item, draw-params)
        bounds = layout.update-bounds(bounds, b, draw-params.em)
        result
      } else if item.qc-instr == "slice" {
        assert(item.wires >= 0, message: "slice: wires arg needs to be > 0")
        assert(y+item.wires <= rowheights.len(), message: "slice: number of wires exceeds range")
        let end = if item.wires == 0 {rowheights.len()} else {y+item.wires}
        let y1 = layout.get-cell-coords(center-y-coords, rowheights, y)
        let y2 = layout.get-cell-coords(center-y-coords, rowheights, end)
        let x_ = layout.get-cell-coords(center-x-coords, colwidths, x)
        let (result, b) = draw-functions.draw-slice(x_, y1, y2, item, draw-params)
        bounds = layout.update-bounds(bounds, b, draw-params.em)
        result
      } else if item.qc-instr == "annotate" {
        let rows = layout.get-cell-coords(center-y-coords, rowheights, item.rows)
        let cols = layout.get-cell-coords(center-x-coords, colwidths, item.columns)
        let annotation = (item.callback)(cols, rows)
        if type(annotation) == "dictionary" {
          assert("content" in annotation, message: "Missing field 'content' in annotation")
          let (content, b) = layout.place-with-labels(
            annotation.content,
            dx: annotation.at("dx", default: 0pt),
            dy: annotation.at("dy", default: 0pt),
            draw-params: draw-params
          )
          content 
          bounds = layout.update-bounds(bounds, b, draw-params.em)
        } else if type(annotation) in ("content", "string") {
          place(annotation)
        } else {
          assert(false, message: "Unsupported annotation type")
        }
      }
    }

    let get-anchor-width(x, y) = {
      if x == num-cols { return 0pt }
      let el = matrix.at(y).at(x)
      if "box" in el and not el.box { return 0pt }
      return el.size.width
    }

    let get-anchor-height(x, y) = {
      let el = matrix.at(y).at(x)
      if "box" in el and not el.box { return 0pt }
      return el.size.height
    }


    let wire-style = default-wire-style
    for wire-piece in wire-instructions {
      if type(wire-piece) == dictionary {
        wire-style = wire-piece
      } else {
        if wire-style.count == 0 { continue }
        let (row, start, end) = wire-piece

        let draw-subwire(x1, x2) = {
          let (a, b) = (x1, x2)
          let g1-w = get-anchor-width(x1, row)
          let g2-w = get-anchor-width(x2, row)
          let x1 = center-x-coords.at(x1)
          let x2 = center-x-coords.at(x2, default: circuit-width)
          let y = center-y-coords.at(row)
          x1 += g1-w / 2
          x2 -= g2-w / 2
          draw-functions.draw-horizontal-wire(x1, x2, y, wire-style.stroke, wire-style.count, wire-distance: wire-style.distance)
        }
        for x in range(start + 1, end) {
          let w = get-anchor-width(x, row)
          if w == 0pt { continue }
          draw-subwire(start, x)
          start = x
        }
        draw-subwire(start, end)
      }
    }
    
    for (x, y, target, wire-style, labels) in vertical-wires {
      let (dx, dy1) = (center-x-coords.at(x), center-y-coords.at(y))
      let dy2 = center-y-coords.at(y + target)
      dy1 += get-anchor-height(x, y) / 2 * signum(target)
      dy2 -= get-anchor-height(x, y + target) / 2 * signum(target)
      
      if labels.len() == 0 {
        draw-functions.draw-vertical-wire(
          dy1, dy2, dx, 
          wire, wire-count: wire-style.count,
        )
      } else {
        let (result, gate-bounds) = draw-functions.draw-vertical-wire-with-labels(
          dy1, dy2, dx, 
          wire, wire-count: wire-style.count,
          wire-labels: labels,
          draw-params: draw-params
        )
        result
        bounds = layout.update-bounds(bounds, gate-bounds, draw-params.em)
      }
      // draw-functions.draw-vertical-wire(
      //   dy1, dy2, dx, 
      //   wire, wire-count: wire-style.count,
      // )
    }
    
    
    for gate-info in gates {
      let (gate, size, x, y) = gate-info
      let (dx, dy) = get-gate-pos(x, y, size)
      let content = utility.get-content(gate, draw-params)

      let (result, gate-bounds) = layout.place-with-labels(
        content, 
        size: size,
        dx: dx, dy: dy, 
        labels: gate.labels, draw-params: draw-params
      )
      bounds = layout.update-bounds(bounds, gate-bounds, draw-params.em)
      result
    }
    
    for gate-info in mqgates {
      let (gate, size, x, y) = gate-info
      let draw-params = draw-params
      gate.qubit = y
      if gate.multi.num-qubits > 1 {
        let y1 = center-y-coords.at(y + gate.multi.num-qubits - 1)
        let y2 = center-y-coords.at(y)
        draw-params.multi.wire-distance = y1 - y2
      }
      
      // lsticks need their offset to be updated again
      let size1 = utility.get-size-hint(gate, draw-params)
      size.offset = size1.offset

      let (dx, dy) = get-gate-pos(x, y, size)
      let content = utility.get-content(gate, draw-params)
      // let content = none
      let (result, gate-bounds) = layout.place-with-labels(
        content, 
        size: if gate.multi != none and gate.multi.num-qubits > 1 {auto} else {size},
        dx: dx, dy: dy, 
        labels: gate.labels, draw-params: draw-params
      )
      bounds = layout.update-bounds(bounds, gate-bounds, draw-params.em)
      result
    }

    // show matrix
    // for (i, row) in matrix.enumerate() {
    //   for (j, entry) in row.enumerate() {
    //     let (dx, dy) = (center-x-coords.at(j), center-y-coords.at(i))
    //     place(
    //       dx: dx - entry.size.width / 2, dy: dy - entry.size.height / 2, 
    //       box(stroke: green, width: entry.size.width, height: entry.size.height)
    //     )
    //   }
    // }
  
  }) // end circuit = block(..., {
    
  /////////// END Second pass: Generation ///////////
  // grace period backwards-compatibility:
  let scale = scale
  if scale-factor != 100% { scale = scale-factor }
  let scale-float = scale / 100%
  if circuit-padding != none {
    let circuit-padding = process-args.process-padding-arg(circuit-padding)
    bounds.at(0) -= circuit-padding.left
    bounds.at(1) -= circuit-padding.top
    bounds.at(2) += circuit-padding.right
    bounds.at(3) += circuit-padding.bottom
  }
  let final-height = scale-float * (bounds.at(3) - bounds.at(1))
  let final-width = scale-float * (bounds.at(2) - bounds.at(0))
  
  let thebaseline = baseline
  if type(thebaseline) in ("content", "string") {
    thebaseline = height/2 - measure(thebaseline, styles).height/2
  }
  if type(thebaseline) == "fraction" {
    thebaseline = 100% - layout.get-cell-coords1(center-y-coords, rowheights, thebaseline / 1fr) + bounds.at(1)
  }
  box(baseline: thebaseline,
    width: final-width,
    height: final-height, 
    // stroke: 1pt + gray,
    align(left + top, move(dy: -scale-float * bounds.at(1), dx: -scale-float * bounds.at(0), 
      layout.std-scale(
        x: scale, 
        y: scale, 
        origin: left + top, 
        circuit
    )))
  )
  
})
}