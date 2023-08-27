#import "layout.typ"


#let process-padding-arg(padding) = {
  let type = type(padding)
  if type == "length" { 
    return (left: padding, top: padding, right: padding, bottom: padding)
  }
  if type == "dictionary" {
    let rest = padding.at("rest", default: 0pt)
    let x = padding.at("x", default: rest)
    let y = padding.at("y", default: rest)
    return (
      left: padding.at("left", default: x), 
      right: padding.at("right", default: x), 
      top: padding.at("top", default: y), 
      bottom: padding.at("bottom", default: y), 
    )
  }
  assert(false, message: "Unsupported type \"" + type + "\" as argument for padding")
}


/// Process the label argument to `gate`. Allowed input formats are array of dictionaries
/// or a single dictionary (for just one label). The dictionary needs to contain the key 
/// content and may optionally have values for the  keys `pos` (specifying a 1d or 2d 
/// alignment) and `dx` as well as `dy`
#let process-labels-arg(labels, default-pos: right) = {
  if type(labels) == "dictionary" { labels = (labels,) } 
  let processed-labels = ()
  for label in labels {
    let alignment = layout.make-2d-alignment(label.at("pos", default: default-pos))
    let (x, y) = layout.make-2d-alignment-factor(alignment)
    processed-labels.push((
      content: label.content,
      pos: alignment,
      dx: label.at("dx", default: .3em * x),
      dy: label.at("dy", default: .3em * y)
    ))
  }
  processed-labels
}