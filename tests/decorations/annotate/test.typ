#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *

#quantum-circuit(
  1, $H$, ctrl(1), 1, [\ ],
  annotate(2, 1, (cols, rows) => {
    let size = measure($phi$)
    (content: $phi$, dx: cols - size.width / 2, dy: rows - size.height / 2)
  }),
  annotate(0, 0, (cols, rows) => square(size: 4pt, fill: red)),
  1, $X$, 1
)

#pagebreak()

#quantum-circuit(
  1, $H$, 1,
  annotate((0, 2), (0, 1), (cols, rows) => (content: text(size: .6em)[range], dx: cols.at(0), dy: rows.at(1) + 2pt)),
  1
)
