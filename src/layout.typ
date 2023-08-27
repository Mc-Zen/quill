


/// Take an alignment or 2d alignment and return a 2d alignment with the possibly 
/// unspecified axis set to a default value. 
#let make-2d-alignment(alignment, default-vertical: horizon, default-horizontal: center) = {
  if type(alignment).starts-with("2d") { return alignment }
  if alignment.axis() == "horizontal" { return alignment + default-vertical }
  if alignment.axis() == "vertical" { return alignment + default-horizontal }
}


#let make-2d-alignment-factor(alignment) = {
  let alignment = make-2d-alignment(alignment)
  let x = 0
  let y = 0
  if alignment.x == left { x = -1 }
  else if alignment.x == right { x = 1 }
  if alignment.y == top { y = -1 }
  else if alignment.y == bottom { y = 1 }
  return (x, y)
}




#let default-size-hint(item, draw-params) = {
  let func = item.draw-function
  let hint = measure(func(item, draw-params), draw-params.styles)
  hint.offset = auto
  return hint
}
