#import "utility.typ"
#import "draw-functions.typ"
#import "process-args.typ"
#import "layout.typ"


#let convert-em-length(length, em) = {
  if length.em == 0pt { return length }
  return length.abs + length.em / 1em * em
}

#let get-length(length, container-length) = {
  if type(length) == "length" { return length }
  if type(length) == "ratio" { return length * container-length}
  if type(length) == "relative length" { return length.length + length.ratio * container-length}
}

/// Update bounds to contain the given rectangle
/// - bounds (array): Current bound coordinates x0, y0, x1, y1
/// - rect (array): Bounds rectangle x0, y0, x1, y1
#let update-bounds(bounds, rect, em) = (
  calc.min(bounds.at(0), convert-em-length(rect.at(0), em)), 
  calc.min(bounds.at(1), convert-em-length(rect.at(1), em)),
  calc.max(bounds.at(2), convert-em-length(rect.at(2), em)),
  calc.max(bounds.at(3), convert-em-length(rect.at(3), em)),
)

#let offset-bounds(bounds, offset) = (
  bounds.at(0) + offset.at(0),
  bounds.at(1) + offset.at(1),
  bounds.at(2) + offset.at(0),
  bounds.at(3) + offset.at(1),
)

#let make-bounds(x0: 0pt, y0: 0pt, width: 0pt, height: 0pt, x1: none, y1: none, em) = (
  convert-em-length(x0, em),
  convert-em-length(y0, em),
  convert-em-length(if x1 != none { x1 } else { x0 + width }, em),
  convert-em-length(if y1 != none { y1 } else { y0 + height }, em),
)




/// Place some content along with optional labels while computing bounds. 
/// 
/// Returns a pair of the placed content and a bounds array. 
///
/// - content (content): The content to place. 
/// - dx (length): Horizontal displacement.
/// - dy (length): Vertical displacement.
/// - size (auto, dictionary): For computing bounds, the size of the placed content
///           is needed. If `auto` is passed, this function computes the size itself
///           but if it is already known it can be passed through this parameter. 
/// - labels (array): An array of labels which in turn are dictionaries that must 
///           specify values for the keys `content` (content), `pos` (strictly 2d 
///           alignment), `dx` and `dy` (both length, ratio or relative length).
/// - draw-params (dictionary): Drawing parameters. Must contain a styles object at 
///           the key `styles` and an absolute length at the key `em`. 
/// -> pair
#let place-with-labels(
  content, 
  dx: 0pt, 
  dy: 0pt,
  size: auto,
  labels: (),
  draw-params: none,
) = {
  if size == auto { size = measure(content, draw-params.styles) }
  let bounds = make-bounds(
    x0: dx, y0: dy, width: size.width, height: size.height, draw-params.em
  )
  if labels.len() == 0 {
    return (place(content, dx: dx, dy: dy), bounds)    
  }
  
  let offset = (dx, dy)
  let placed-labels = place(dx: dx, dy: dy, 
    box(width: size.width, height: size.height, {
      for label in labels {
        let label-size = measure(label.content, draw-params.styles)
        let ldx = get-length(label.dx, size.width)
        let ldy = get-length(label.dy, size.height)
        
        if label.pos.x == left { ldx -= label-size.width }
        else if label.pos.x == center { ldx += 0.5 * (size.width - label-size.width) }
        else if label.pos.x == right { ldx += size.width }
        if label.pos.y == top { ldy -= label-size.height }
        else if label.pos.y == horizon { ldy += 0.5 * (size.height - label-size.height) }
        else if label.pos.y == bottom { ldy += size.height }
        
        let placed-label = place(label.content, dx: ldx, dy: ldy)
        let label-bounds = make-bounds(
          x0: ldx + dx, y0: ldy + dy, 
          width: label-size.width, height: label-size.height, 
          draw-params.em
        )
        bounds = update-bounds(bounds, label-bounds, draw-params.em)
        placed-label
      }
    })
  )
  return (place(content, dx: dx, dy: dy) + placed-labels, bounds)
}



#let lrstick-size-hint(gate, draw-params) = {
  let content = box(inset: draw-params.padding, gate.content)
  let size = measure(content, draw-params.styles)
  let hint = (
    width1: 2 * size.width,
    width: 1 * size.width,
    height: size.height,
  )
  return hint
}


#let draw-gategroup(x1, x2, y1, y2, item, draw-params) = {
  let p = item.padding
  let (x1, x2, y1, y2) = (x1 - p.left, x2 + p.right, y1 - p.top, y2 + p.bottom)
  let size = (width: x2 - x1, height: y2 - y1)
  place-with-labels(
    dx: x1, dy: y1, 
    labels: item.labels, 
    size: size,
    draw-params: draw-params, rect(
      width: size.width, height: size.height,
      stroke: item.style.stroke,
      fill: item.style.fill,
      radius: item.style.radius
    )
  )
}

#let draw-slice(x, y1, y2, item, draw-params) = place-with-labels(
  dx: x, dy: y1, 
  size: (width: 0pt, height: y2 - y1),
  labels: item.labels, draw-params: draw-params, 
  line(angle: 90deg, length: y2 - y1, stroke: item.style.stroke)
)




/// This is the basic command for creating gates. Use this to create a simple gate, e.g., `gate($X$)`. 
/// For special gates, many other dedicated gate commands exist. 
///
/// Note, that most of the parameters listed here are mostly used for derived gate 
/// functions and do not need to be touched in all but very few cases. 
///
/// - content (content): What to show in the gate (may be none for special gates like @@ctrl).
/// - fill (none, color): Gate backgrond fill color.
/// - radius (length, dictionary): Gate rectangle border radius. 
///             Allows the same values as the builtin `rect()` function.
/// - width (auto, length): The width of the gate can be specified manually with this property. 
/// - box (boolean): Whether this is a boxed gate (determines whether the outgoing 
///             wire will be drawn all through the gate (`box: false`) or not).
/// - floating (boolean): Whether the content for this gate will be shown floating 
///             (i.e. no width is reserved).
/// - multi (dictionary): Information for multi-qubit and controlled gates (see @@mqgate() ).
/// - size-hint (function): Size hint function. This function should return a dictionary
///             containing the keys `width` and `height`. The result is used to determine 
///             the gates position and cell sizes of the grid. 
///             Signature: `(gate, draw-params).`
/// - draw-function (function): Drawing function that produces the displayed content.
///             Signature: `(gate, draw-params).`
/// - labels (array, dictionary): One or more labels to add to the gate. A label consists
///             of a dictionary with entries for the keys `content` (the label content), 
///             `pos` (2d alignment specifying the position of the label) and 
///             optionally `dx` and/or `dy` (lengths, ratios or relative 
///             lengths). 
///
/// - data (any): Optional additional gate data. This can for example be a dictionary
///             storing extra information that may be used for instance in a custom
///             `draw-function`.
#let gate(
  content,
  fill: none,
  radius: 0pt,
  width: auto,
  box: true,
  floating: false,
  multi: none,
  size-hint: layout.default-size-hint,
  draw-function: draw-functions.draw-boxed-gate,
  gate-type: "",
  data: none,
  labels: ()
) = (
  content: content, 
  fill: fill,
  radius: radius,
  width: width,
  box: box,
  floating: floating,
  multi: multi,
  size-hint: size-hint,
  draw-function: draw-function,
  gate-type: gate-type, 
  data: data,
  labels: process-args.process-labels-arg(labels)
)



/// Basic command for creating multi-qubit or controlled gates. See also @@ctrl and @@swap. 
///
/// - content (content):
/// - n (integer): Number of wires the multi-qubit gate spans. 
/// - target (none, integer): If specified, a control wire is drawn from the gate up 
///        or down this many wires counted from the wire this `mqgate()` is placed on. 
/// - fill (none, color): Gate backgrond fill color.
/// - radius (length, dictionary): Gate rectangle border radius. 
///        Allows the same values as the builtin `rect()` function.
/// - width (auto, length): The width of the gate can be specified manually with this property. 
/// - box (boolean): Whether this is a boxed gate (determines whether the 
///        outgoing wire will be drawn all through the gate (`box: false`) or not).
/// - label (content): Optional label on the vertical wire. 
/// - wire-count (integer): Wire count for control wires.
/// - inputs (none, array): You can put labels inside the gate to label the input wires with 
///        this argument. It accepts a list of labels, each of which has to be a dictionary
///        with the keys `qubit` (denoting the qubit to label, starting at 0) and `content`
///        (containing the label content). Optionally, providing a value for the key `n` allows
///        for labelling multiple qubits spanning over `n` wires. These are then grouped by a 
///        brace. 
/// - outputs (none, array): Same as `inputs` but for gate outputs. 
/// - extent (auto, length): How much to extent the gate beyond the first and 
///        last wire, default is to make it align with an X gate (so [size of x gate] / 2). 
/// - size-all-wires (none, boolean): A single-qubit gate affects the height of the row
///        it is being put on. For multi-qubit gate there are different possible 
///        behaviours:
///          - Affect height on only the first and last wire (`false`)
///          - Affect the height of all wires (`true`)
///          - Affect the height on no wire (`none`)
/// - labels (array, dictionary): One or more labels to add to the gate. See @@gate(). 
/// - data (any): Optional additional gate data. This can for example be a dictionary
///        storing extra information that may be used for instance in a custom
///        `draw-function`.
#let mqgate(
  content,
  n: 1, 
  target: none,
  fill: none, 
  radius: 0pt,
  width: auto,
  box: true, 
  label: none, 
  wire-count: 1,
  inputs: none,
  outputs: none,
  extent: auto, 
  size-all-wires: false,
  draw-function: draw-functions.draw-boxed-multigate, 
  data: none,
  labels: (),
) = gate(
  content, 
  fill: fill, box: box, 
  width: width,
  radius: radius,
  draw-function: draw-function,
  multi: (
    target: target,
    num-qubits: n, 
    wire-count: wire-count, 
    label: label,
    extent: extent,
    size-all-wires: size-all-wires,
    inputs: inputs,
    outputs: outputs,
  ),
  labels: labels,
  data: data,
)


// align: "left" (for rstick) or "right" (for lstick)
// brace: auto, none, "{", "}", "|", "[", ...
#let lrstick(content, n, align, brace) = gate(
  content, 
  draw-function: draw-functions.draw-lrstick.with(align: align), 
  // size-hint: lrstick-size-hint,
  box: false, 
  floating: true,
  multi: if n == 1 { none } else { 
   (
    target: none,
    num-qubits: n, 
    wire-count: 0, 
    label: label,
    size-all-wires: if n > 1 { none } else { false }
  )},
  data: (brace: brace), 
  // labels: (content: "a", pos: top)
)


// SPECIAL GATES

/// Draw a meter box representing a measurement. 
/// - target (none, integer): If given, draw a control wire to the given target
///                           qubit the specified number of wires up or down.
/// - wire-count (integer):   Wire count for the (optional) control wire. 
/// - n (integer):            Number of wires to span this meter across. 
/// - label (content):        Label to show above the meter. 
#let meter(target: none, n: 1, wire-count: 2, label: none, fill: none, radius: 0pt) = {
  let labels = if label != none {(content: label, pos: top, dy: -0.5em)} else { () }
  if target == none and n == 1 {
    gate(none, fill: fill, radius: radius, draw-function: draw-functions.draw-meter, data: (meter-label: label), labels: labels)
  } else {
     mqgate(none, n: n, target: target, fill: fill, radius: radius, box: true, wire-count: wire-count, draw-function: draw-functions.draw-meter, data: (meter-label: label), labels: labels)
  }
}

/// Create a visualized permutation gate which maps the qubits $q_k, q_(k+1), ... $ to  
/// the qubits $q_(p(k)), q_(p(k+1)), ...$ when placed on the qubit $k$. The permutation 
/// map is given by the `qubits` argument. Note, that qubit indices start with 0. 
/// 
/// *Example:*
///
///  `permute(1, 0)` when placed on the second wire swaps the second and third wire. 
/// 
///  `permute(2, 0, 1)` when placed on wire 0 maps $(0,1,2) arrow.bar (2,0,1)$.
/// 
/// Note also, that the wiring is not very sophisticated and will probably look best for 
/// relatively simple permutations. Furthermore, it only works with quantum wires. 
///  
/// - ..qubits (array): Qubit permutation specification. 
/// - width (length): Width of the permutation gate. 
/// 
#let permute(..qubits, width: 30pt) = {
  mqgate(none, n: qubits.pos().len(), width: width, draw-function: draw-functions.draw-permutation-gate, data: (qubits: qubits.pos(), extent: 2pt))
}

/// Create an invisible (phantom) gate for reserving space. If `content` 
/// is provided, the `height` and `width` parameters are ignored and the gate 
/// will take the size it would have if `gate(content)` was called. 
///
/// Instead specifying width and/or height will create a gate with exactly the
/// given size (without padding).
///
/// - content (content): Content to measure for the phantom gate size. 
/// - width (length): Width of the phantom gate (ignored if `content` is not `none`). 
/// - height (length): Height of the phantom gate (ignored if `content` is not `none`). 
#let phantom(content: none, width: 0pt, height: 0pt) = {
  let thecontent = if content != none { box(hide(content)) } else { 
    let w = height
    if type(w) in ("content", "string") { }
    box(width: width, height: height) 
  }
  gate(thecontent, box: false, fill: none)
}

/// Target element for controlled #smallcaps("x") operations (#sym.plus.circle). 
/// - fill (none, color, boolean): Fill color for the target circle. If set 
///        to `true`, the target is filled with the circuits background color.
/// - size (length): Size of the target symbol. 
#let targ(fill: none, size: 4.3pt, labels: ()) = gate(none, box: false, draw-function: draw-functions.draw-targ, fill: fill, data: (size: size), labels: labels)

/// Target element for controlled #smallcaps("z") operations (#sym.bullet). 
///
/// - open (boolean): Whether to draw an open dot. 
/// - fill (none, color): Fill color for the circle or stroke color if
///        `open: true`. 
/// - size (length): Size of the control circle. 
// #let ctrl(open: false, fill: none, size: 2.3pt) = gate(none, draw-function: draw-ctrl, fill: fill, size: size, box: false, open: open)

/// Target element for #smallcaps("swap") operations (#sym.times) without vertical wire). 
/// - size (length): Size of the target symbol. 
#let targX(size: 7pt, labels: ()) = gate(none, box: false, draw-function: draw-functions.draw-swap, data: (size: size), labels: labels)

/// Create a phase gate shown as a point on the wire together with a label. 
///
/// - label (content): Angle value to display. 
/// - open (boolean): Whether to draw an open dot. 
/// - fill (none, color): Fill color for the circle or stroke color if
///        `open: true`. 
/// - size (length): Size of the circle. 
#let phase(label, open: false, fill: none, size: 2.3pt, labels: ()) = gate(
  none, 
  box: false,
  draw-function: (gate, draw-params) => {
      box(inset: (x: .6em), draw-functions.draw-ctrl(gate, draw-params))
    },
  fill: fill,
  data: (open: open, size: size),
  labels: ((content: label, pos: top + right, dx: -.5em), ) + labels
)




/// Basic command for labelling a wire at the start. 
/// - content (content): Label to display, e.g., `$|0〉$`.
/// - n (content): How many wires the `lstick` should span. 
/// - brace (auto, none, string): If `brace` is `auto`, then a default `{` brace
///      is shown only if `n > 1`. A brace is always shown when 
///      explicitly given, e.g., `"}"`, `"["` or `"|"`. No brace is shown for 
///      `brace: none`. 
#let lstick(content, n: 1, brace: auto) = lrstick(content, n, "right", brace)


/// Basic command for labelling a wire at the end. 
/// - content (content): Label to display, e.g., `$|0〉$`.
/// - n (content): How many wires the `rstick` should span. 
/// - brace (auto, none, string): If `brace` is `auto`, then a default `}` brace
///      is shown only if `n > 1`. A brace is always shown when 
///      explicitly given, e.g., `"}"`, `"["` or `"|"`. No brace is shown for 
///      `brace: none`. 
#let rstick(content, n: 1, brace: auto) = lrstick(content, n, "left", brace)

/// Create a midstick
#let midstick(content) = gate(content, draw-function: draw-functions.draw-unboxed-gate)



/// Creates a symbol similar to `\qwbundle` on `quantikz`. Annotates a wire to 
/// be a bundle of quantum or classical wires. 
/// - label (integer, content): 
#let nwire(label) = gate([#label], draw-function: draw-functions.draw-nwire, box: false)

/// Create a controlled gate. See also @@ctrl. This function however
/// may be used to create controlled gates where a gate box is at both ends
/// of the control wire. 
/// 
/// *Example: *
/// `controlled($H$, 2)`. 
/// 
/// - content (content): Gate content to display.
/// - n (integer): How many wires up or down the target wire lives. 
/// - wire-count (integer): Wire count for the control wire.  
/// - draw-function (function). See @@gate. 
/// - ..args (array): Optional, additional arguments to be stored in the gate. 
// #let controlled(content, n, wire-count: 1, draw-function: draw-boxed-gate, ..args) = mqgate(content, target: n, wire-count: wire-count, draw-function: draw-function, ..args)

/// Creates a #smallcaps("swap") operation with another qubit. 
/// 
/// - n (integer): How many wires up or down the target wire lives. 
/// - size (length): Size of the target symbol. 
#let swap(n, size: 7pt, labels: ()) = mqgate(none, target: n, box: false, draw-function: draw-functions.draw-swap, data: (size: size), labels: labels)

/// Creates a control with a vertical wire to another qubit. 
/// 
/// - n (integer): How many wires up or down the target wire lives. 
/// - wire-count (integer): Wire count for the control wire.  
/// - open (boolean): Whether to draw an open dot. 
/// - fill (none, color): Fill color for the circle or stroke color if
///        `open: true`. 
/// - size (length): Size of the control circle. 
/// - show-dot (boolean): Whether to show the control dot. Set this to 
///        false to obtain a vertical wire with no dots at all. 
#let ctrl(n, wire-count: 1, open: false, fill: none, size: 2.3pt, show-dot: true, labels: ()) = mqgate(none, target: n, draw-function: draw-functions.draw-ctrl, wire-count: wire-count, fill: fill, data: (open: open, size: size, show-dot: show-dot), labels: labels)




// META INSTRUCTIONS

/// Set current wire mode (0: none, 1 wire: quantum, 2 wires: classical, more  
/// are possible) and optionally the stroke style. 
///
/// The wire style is reset for each row.
///
/// - wire-count (integer): Number of wires to display. 
/// - stroke (none, stroke): When given, the stroke is applied to the wire. 
///                Otherwise the current stroke is kept. 
/// - wire-distance (length): Distance between wires. 
#let setwire(wire-count, stroke: none, wire-distance: 1pt) = (
  qc-instr: "setwire",
  wire-count: wire-count,
  stroke: stroke,
  wire-distance: wire-distance
)

/// Highlight a group of circuit elements by drawing a rectangular box around
/// them. 
/// 
/// - wires (integer): Number of wires to include.
/// - steps (integer): Number of columns to include.
/// - padding (length, dictionary): Padding of rectangle. May be one length
///     for all sides or a dictionary with the keys `left`, `right`, `top`, 
///     `bottom` and `default`. Not all keys need to be specified. The value 
///     for `default` is used for the omitted sides or `0pt` if no `default` 
///     is given. 
/// - stroke (stroke): Stroke for rectangle.
/// - fill (color): Fill color for rectangle.
/// - radius (length, dictionary): Corner radius for rectangle.
#let gategroup(
  wires, 
  steps, 
  padding: 0pt, 
  stroke: .7pt, 
  fill: none,
  radius: 0pt,
  labels: ()
) = (
  qc-instr: "gategroup",
  wires: wires,
  steps: steps,
  padding: process-args.process-padding-arg(padding),
  style: (fill: fill, stroke: stroke, radius: radius),
  labels: process-args.process-labels-arg(labels, default-pos: top)
)

/// Slice the circuit vertically, showing a separation line between columns. 
/// 
/// - wires (integer): Number of wires to slice.
/// - labels (array, dictionary): Labels for the slice. See @@gate()
/// - stroke (stroke): Line style for the slice. 
#let slice(
  wires: 0, 
  stroke: (paint: red, thickness: .7pt, dash: "dashed"),
  labels: ()
) = (
  qc-instr: "slice",
  wires: wires,
  style: (stroke: stroke),
  labels: process-args.process-labels-arg(labels, default-pos: top)
)

/// Lower-level interface to the cell coordinates to create an arbitrary
/// annotatation by passing a custom function.
/// 
/// This function is passed the coordinates of the specified cell rows 
/// and columns. 
/// 
/// - rows (integer, array): Row indices for which to obtain coordinates. 
/// - columns (integer, array): Column indices for which to obtain coordinates. 
/// - callback (function): Function to call with the obtained coordinates. The
///     signature should be with signature `(row-coords, col-coords) => {}`. 
///     This function is expected to display the content to draw in absolute 
///     coordinates within the circuit. 
#let annotate(
  rows,
  columns,
  callback 
) = (
  qc-instr: "annotate",
  rows: rows,
  columns: columns,
  callback: callback
)




// From a list of row heights or col widths, compute the respective
// cell center coordinates, e.g., (3pt, 3pt, 4pt) -> (1.5pt, 4.5pt, 8pt)
#let compute-center-coords(cell-lengths, gutter) = {
  let center-coords = ()
  let tmpx = 0pt
  gutter.insert(0, 0pt)
  // assert.eq(cell-lengths.len(), gutter.len())
  for (cell-length, gutter) in cell-lengths.zip(gutter) {
    center-coords.push(tmpx + cell-length / 2 + gutter)
    tmpx += cell-length + gutter
  }
  return center-coords
} 

// Given a list of n center coordinates in and n cell sizes along one axis (x or y), retrieve the coordinates for a single cell or a list of cells given by index. 
// If a cell index is out of bounds, the outer last coordinate is returned
// center-coords: List of center coordinates for each index
// cell-sizes: List of cell sizes for each index
// cells: Indices of cell for which to retrieve coordinates
// mode: "center" or "start"
#let obtain-cell-coords(center-coords, cell-sizes, cells, mode) = {
  assert(mode in ("center", "start", "end"), message:"Only \"center\", \"start\" and \"end\" are allowed for cell coordinate mode")
  let last = center-coords.at(-1) + cell-sizes.at(-1) / 2
  let get(x) = { 
    let coord = center-coords.at(x, default: last)
    if mode == "start" { coord -= cell-sizes.at(x, default: 0pt)/2 }
    if mode == "end" { coord += cell-sizes.at(x, default: 0pt)/2 }
    return coord
  }
  if type(cells) == "integer" { get(cells)  }
  else if type(cells) == "array" { cells.map(x => get(x)) }
  else { panic("Unsupported coordinate type") }
}

// Given a list of n center coordinates in and n cell sizes along one axis (x or y), retrieve the coordinates for a single cell or a list of cells given by index. 
// If a cell index is out of bounds, the outer last coordinate is returned
// center-coords: List of center coordinates for each index
// cell-sizes: List of cell sizes for each index
// cells: Indices of cell for which to retrieve coordinates
// These may also be floats. In this case, the integer part determines the cell index and the fractional part a percentage of the cell width. e.g., passing 2.5 would return the center coordinate of the cell
#let obtain-cell-coords1(center-coords, cell-sizes, cells) = {
  let last = center-coords.at(-1) + cell-sizes.at(-1) / 2
  let get(x) = { 
    let integral = calc.floor(x)
    let fractional = x - integral
    let cell-width = cell-sizes.at(integral, default: 0pt)
    return center-coords.at(integral, default: last) + cell-width * (fractional - 0.5)
  }
  if type(cells) in ("integer", "float") { get(cells)  }
  else if type(cells) == "array" { cells.map(x => get(x)) }
  else { panic("Unsupported coordinate type") }
}


#let draw-horizontal-wire(x1, x2, y, stroke, wire-count, wire-distance: 1pt) = {
  if x1 == x2 { return }
  for i in range(wire-count) {
    place(line(start: (x1, y), end: (x2, y), stroke: stroke), 
      dy: (2*i - (wire-count - 1)) * wire-distance)
  }
}

#let draw-vertical-wire(y1, y2, x, stroke, wire-count: 1, wire-distance: 1pt) = {
  for i in range(wire-count) {
    place(line(start: (x, y1), end: (x, y2), stroke: stroke), 
      dx: (2*i - int(wire-count/2)) * wire-distance)
  }
}

#let std-scale = scale

/// Create a quantum circuit diagram. Content items may be
/// - Gates created by one of the many gate commands (@@gate, 
///   @@mqgate, @@meter, ...)
/// - `[\ ]` for creating a new wire/row 
/// - Commands like @@setwire or @@gategroup
/// - Integers for creating cells filled with the current wire setting 
/// - Lengths for creating space between rows or columns 
/// - Plain content or strings to be placed on the wire 
/// - @@lstick, @@midstick or @@rstick for placement next to the wire 
///
/// - wire (stroke): Style for drawing the circuit wires. This can take anything 
///            that is valid for the stroke of the builtin `line()` function. 
/// - row-spacing (length): Spacing between rows.
/// - column-spacing (length): Spacing between columns.
/// - min-row-height (length): Minimum height of a row (e.g., when no 
///             gates are given).
/// - min-column-width (length): Minimum width of a column.
/// - gate-padding (length): General padding setting including the inset for 
///            gate boxes and the distance of @@lstick and co. to the wire. 
/// - equal-row-heights (boolean): If true, then all rows will have the same 
///            height and the wires will have equal distances orienting on the
///            highest row. 
/// - color (color): Foreground color, default for strokes, text, controls
///            etc. If you want to have dark-themed circuits, set this to white  
///            for instance and update `wire` and `fill` accordingly.           
/// - fill (color): Default fill color for gates. 
/// - font-size (length): Default font size for text in the circuit. 
/// - scale (ratio): Total scale factor applied to the entire 
///            circuit without changing proportions
/// - baseline (length, content, string): Set the baseline for the circuit. If a 
///            content or a string is given, the baseline will be adjusted auto-
///            matically to align with the center of it. One useful application is 
///            `"="` so the circuit aligns with the equals symbol. 
/// - circuit-padding (dictionary): Padding for the circuit (e.g., to accomodate 
///            for annotations) in form of a dictionary with possible keys 
///            `left`, `right`, `top` and `bottom`. Not all of those need to be 
///            specified. 
///
///            This setting basically just changes the size of the bounding box 
///            for the circuit and can be used to increase it when labels or 
///            annotations extend beyond the actual circuit. 
/// - ..content (array): Items, gates and circuit commands (see description). 
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
  ..content
) = { 
  if content.pos().len() == 0 { return }
  if content.named().len() > 0 { 
    panic("Unexpected named argument '" + content.named().keys().at(0) + "' for quantum-circuit()")
  }
  set text(color, size: font-size)
  
  style(styles => {
  
  // Parameter object to pass to draw-function containing current style info
  let draw-params = (
    wire: wire,
    padding: measure(line(length: gate-padding), styles).width,
    background: fill,
    color: color,
    styles: styles,
    // roman-gates: roman-gates,
    x-gate-size: none,
    multi: (wire-distance: 0pt),
    em: measure(line(length: 1em), styles).width
  )

  draw-params.x-gate-size = layout.default-size-hint(gate($X$), draw-params)
  
  let items = content.pos()
  
  /////////// First pass: Layout (spacing)   ///////////
  
  let column-spacing = convert-em-length(column-spacing, draw-params.em)
  let row-spacing = convert-em-length(row-spacing, draw-params.em)
  let min-row-height = convert-em-length(min-row-height, draw-params.em)
  let min-column-width = convert-em-length(min-column-width, draw-params.em)
  
  let colwidths = ()
  let rowheights = (min-row-height,)
  let (row-gutter, col-gutter) = ((0pt,), ())
  let (row, col) = (0, 0)
  let wire-ended = false
  
  for item in items { 
    if item == [\ ] {
      
      if rowheights.len() < row + 2 { 
        rowheights.push(min-row-height)
        row-gutter.push(0pt)
      }
      row += 1; col = 0
      wire-ended = true
    } else if utility.is-circuit-meta-instruction(item) { 
    } else if utility.is-circuit-drawable(item) {
      let isgate = utility.is-gate(item)
      if isgate { item.qubit = row }
      let ismulti = isgate and item.multi != none
      let size = utility.get-size-hint(item, draw-params)
      
      let width = size.width 
      let height = size.height
      if isgate and item.floating { width = 0pt }

      if colwidths.len() < col + 1 { 
        colwidths.push(min-column-width)
        col-gutter.push(0pt)
      }
      colwidths.at(col) = calc.max(colwidths.at(col), width)
      
      if not (ismulti and item.multi.size-all-wires == none) {
        // e.g., l, rsticks
        rowheights.at(row) = calc.max(rowheights.at(row), height)
      } 
      
      if ismulti and item.multi.num-qubits > 1 and item.multi.size-all-wires != none { 
        let start = row
        if not item.multi.size-all-wires {
          start = calc.max(0, row + item.multi.num-qubits - 1)
        }
        for qubit in range(start, row + item.multi.num-qubits) {
          while rowheights.len() < qubit + 1 { 
            rowheights.push(min-row-height)
            row-gutter.push(0pt)
          }
          rowheights.at(qubit) = calc.max(rowheights.at(qubit), height)
        }
      }
      col += 1
      wire-ended = false
    } else if type(item) == "integer" {
      for _ in range(colwidths.len(), col + item) { 
        colwidths.push(min-column-width)
        col-gutter.push(0pt) 
      }
      col += item
      wire-ended = false
    } else if type(item) == "length" {
      if wire-ended {
        row-gutter.at(row - 1) = calc.max(row-gutter.at(row - 1), item)
      } else if col > 0 {
        col-gutter.at(col - 1) = calc.max(col-gutter.at(col - 1), item)
      }
    }
  }
  /////////// END First pass: Layout (spacing)   ///////////
  
  rowheights = rowheights.map(x => x + row-spacing)
  colwidths = colwidths.map(x => x + column-spacing)

  if equal-row-heights {
    let max-row-height = calc.max(..rowheights)
    rowheights = rowheights.map(x => max-row-height)
  }
  let center-x-coords = compute-center-coords(colwidths, col-gutter).map(x => x - 0.5 * column-spacing)
  let center-y-coords = compute-center-coords(rowheights, row-gutter).map(x => x - 0.5 * row-spacing)
  draw-params.center-y-coords = center-y-coords
  
  (row, col) = (0, 0)
  let (x, y) = (0pt, 0pt) // current cell top-left coordinates
  let center-y = y + rowheights.at(row) / 2 // current cell center y-coordinate
  let center-y = center-y-coords.at(0) // current cell center y-coordinate
  let circuit-width = colwidths.sum() + col-gutter.slice(0, -1).sum(default: 0pt) - column-spacing
  let circuit-height = rowheights.sum() + row-gutter.sum() - row-spacing

  let wire-count = 1
  let wire-distance = 1pt
  let wire-stroke = wire
  let prev-wire-x = center-x-coords.at(0)

  /////////// Second pass: Generation ///////////
  let bounds = (0pt, 0pt, circuit-width, circuit-height)
  
  let circuit = block(
    width: circuit-width, height: circuit-height, {
    set align(top + left) // quantum-circuit could be called in a scope where these have been changed which would mess up everything

    let to-be-drawn-later = () // dicts with content, x and y
      
    for item in items {
      if item == [\ ]{
        y += rowheights.at(row)
        row += 1
        center-y = center-y-coords.at(row)
        col = 0; x = 0pt
        wire-count = 1; wire-stroke = wire
        prev-wire-x = center-x-coords.at(0)
        
      } else if utility.is-circuit-meta-instruction(item) {
        if item.qc-instr == "setwire" {
          wire-count = item.wire-count
          wire-distance = item.wire-distance
          if item.stroke != none { wire-stroke = item.stroke }
        } else if item.qc-instr == "gategroup" {
          assert(item.wires > 0, message: "gategroup: wires arg needs to be > 0")
          assert(row+item.wires <= rowheights.len(), message: "gategroup: height exceeds range")
          assert(item.steps > 0, message: "gategroup: steps arg needs to be > 0")
          assert(col+item.steps <= colwidths.len(), message: "gategroup: width exceeds range")
          let y1 = obtain-cell-coords1(center-y-coords, rowheights, row)
          let y2 = obtain-cell-coords1(center-y-coords, rowheights, row + item.wires - 1e-9)
          let x1 = obtain-cell-coords1(center-x-coords, colwidths, col)
          let x2 = obtain-cell-coords1(center-x-coords, colwidths, col + item.steps - 1e-9)
          let (result, b) = draw-gategroup(x1, x2, y1, y2, item, draw-params)
          bounds = update-bounds(bounds, b, draw-params.em)
          result
        } else if item.qc-instr == "slice" {
          assert(item.wires >= 0, message: "slice: wires arg needs to be > 0")
          assert(row+item.wires <= rowheights.len(), message: "slice: height exceeds range")
          let end = if item.wires == 0 {rowheights.len()} else {row+item.wires}
          let y1 = obtain-cell-coords1(center-y-coords, rowheights, row)
          let y2 = obtain-cell-coords1(center-y-coords, rowheights, end)
          let x = obtain-cell-coords1(center-x-coords, colwidths, col)
          let (result, b) = draw-slice(x, y1, y2, item, draw-params)
          bounds = update-bounds(bounds, b, draw-params.em)
          result
        } else if item.qc-instr == "annotate" {
          let rows = obtain-cell-coords1(center-y-coords, rowheights, item.rows)
          let cols = obtain-cell-coords1(center-x-coords, colwidths, item.columns)
          place((item.callback)(rows, cols))
        }
      // ---------------------------- Gates & Co. ------------------------------
      } else if utility.is-circuit-drawable(item) {
        
        let isgate = utility.is-gate(item)
        
        let size = utility.get-size-hint(item, draw-params)        
        let center-x = center-x-coords.at(col)
        let top = center-y - size.height / 2
        let bottom = center-y + size.height / 2
  

        if isgate {
          item.qubit = row
          if item.box == false {
            bottom = center-y
            top = center-y
          }
          if item.multi != none {
            if item.multi.target != none {
              let target-qubit = row + item.multi.target
              assert(center-y-coords.len() > target-qubit, message: "Target qubit for controlled gate is out of range")
              let (y1, y2) = ((bottom, top).at(int(item.multi.target < 1)), center-y-coords.at(target-qubit))
              draw-vertical-wire(
                y1, 
                y2, 
                center-x, 
                wire, 
                wire-count: item.multi.wire-count
              )
            } 
            let nq = item.multi.num-qubits
            if nq > 1 {
              assert(row + nq - 1 < center-y-coords.len(), message: "Target 
              qubit for multi qubit gate does not exist")
              let y1 = center-y-coords.at(row + nq - 1)
              let y2 = center-y-coords.at(row)
              draw-params.multi.wire-distance = y1 - y2
              let func = item.size-hint
              size.width = func(item, draw-params).width
            }
          }
        }
        
        let current-wire-x = center-x
        draw-horizontal-wire(prev-wire-x, current-wire-x, center-y, wire-stroke, wire-count, wire-distance: wire-distance)
        if isgate and item.box { prev-wire-x = center-x + size.width / 2 } 
        else { prev-wire-x = current-wire-x }
        
        let x-pos = center-x
        let y-pos = center-y
        let offset = size.at("offset", default: auto)
        if offset == auto {
          x-pos -= size.width / 2
          y-pos -= size.height / 2
        } else if type(offset) == "dictionary" {
          let offset-x = offset.at("x", default: auto)
          let offset-y = offset.at("y", default: auto)
          if offset-x == auto { x-pos -= size.width / 2}
          else if type(offset-x) == "length" { x-pos -= offset-x }
          if offset-y == auto { y-pos -= size.width / 2}
          else if type(offset-y) == "length" { y-pos -= offset-y }
        }
        
        let content = utility.get-content(item, draw-params)

        let result
        if isgate {
          let gate-bounds
          (result, gate-bounds) = place-with-labels(
            content, 
            size: if item.multi != none and item.multi.num-qubits > 1 {auto} else {size},
            dx: x-pos, dy: y-pos, 
            labels: item.labels, draw-params: draw-params
          )
          bounds = update-bounds(bounds, gate-bounds, draw-params.em)
        } else {
          result = place(
            dx: x-pos, dy: y-pos, 
            if isgate { content } else { box(content) }
          )
        }
        to-be-drawn-later.push(result)
      
          
        x += colwidths.at(col)
        col += 1
        draw-params.multi.wire-distance = 0pt
      } else if type(item) == "integer" {
        col += item
        // let t = col
        // if col == center-x-coords.len() { t -= 1}
        let center-x = center-x-coords.at(col - 1)
        draw-horizontal-wire(prev-wire-x, center-x, center-y, wire-stroke, wire-count, wire-distance: wire-distance)
        prev-wire-x = center-x
      }
      
    } // end loop over items
    for item in to-be-drawn-later {
      item
    }
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
  box(baseline: thebaseline,
    width: final-width,
    height: final-height, 
    // stroke: 1pt + gray,
    move(dy: -scale-float * bounds.at(1), dx: -scale-float * bounds.at(0), 
      std-scale(
        x: scale, 
        y: scale, 
        origin: left + top, 
        circuit
    ))
  )
  
})
}