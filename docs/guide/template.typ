// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  abstract: [],
  authors: (),
  url: none,
  date: none,
  version: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: left)
  set text(font: "Linux Libertine", lang: "en")
  set heading(numbering: "I.a")
  show heading.where(level: 1): it => block(smallcaps(it), below: 1em)

  v(4em)


  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title))
    #v(4em, weak: true)
    v#version #h(1.2cm) #date 
    #block(link(url))
    #v(1.5em, weak: true)
  ]

  // Author information.
  pad(
    top: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center, strong(author))),
    ),
  )
  v(4em)

  // Abstract.
  pad(
    x: 2em,
    top: 1em,
    bottom: 1.1em,
    align(center)[
      // #heading(
      //   outlined: false,
      //   numbering: none,
      //   text(0.85em, smallcaps[Abstract]),
      // )
      #abstract
    ],
  )

  // Main body.
  set par(justify: true)

  body
}