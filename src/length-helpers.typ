

#let convert-em-length(length, em) = {
  if length.em == 0pt { return length }
  if type(length.em) == float { return length.abs + length.em * em }
  return length.abs + length.em / 1em * em
}

#let get-length(len, container-length) = {
  if type(len) == length { return len }
  if type(len) == ratio { return len * container-length}
  if type(len) == relative { return len.length + len.ratio * container-length}
}
