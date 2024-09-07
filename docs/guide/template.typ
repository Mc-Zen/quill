#import "../../src/quill.typ"
#import quill: *


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
  set raw(lang: "typc")
  show raw: set text(size: .9em)
  show raw.where(block: true) : set par(justify: false)


  show link: underline.with(offset: 1.2pt)
  show link: set text(fill: purple.darken(30%))

  body
}




#let makefigure(code, content, vertical: false) = {
  align(center,
    box(fill: gray.lighten(90%), inset: .8em, {
      table(
        align: center + horizon, 
        columns: if vertical { 1 } else { 2 }, 
        gutter: 1em,
        stroke: none,
        box(code), block(content)
      )
    })
  )
}
#let stdscale = scale

#let example(code, vertical: false, scope: (:), text-size: 1em, scale: 100%) = {
  figure(
    pad(y: 1em,
      box(fill: gray.lighten(90%), inset: .8em, {
        table(
          align: center + horizon, 
          columns: if vertical { 1 } else { 2 }, 
          gutter: 1em,
          stroke: none,
          {
            set text(size: text-size)
            box(code)
          }, 
          block(stdscale(scale, reflow: true, eval("#import quill: *\n" + code.text, mode: "markup", scope: (quill: quill) + scope)))
        )
      })
    )
  )
}


#let insert-example(filename, fontsize: 1em) = {
  let content = read(filename)
  content = content.slice(content.position("*")+1).trim()
  makefigure(text(size: fontsize, raw(lang: "typ", block: true, content)), [])
  figure(include(filename))
}

#let ref-fn(name) = link(label("quill:" + name), raw(name, lang: ""))
