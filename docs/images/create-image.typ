#set page(width: auto, height: auto, margin: 0pt)

#let scale-factor = 130%
#let content = include("/examples/qft.typ")

#style(styles => {
    let size = measure(content, styles)
    rect(
        stroke: none,
        radius: 3pt,
        inset: (x: 6pt, y: 6pt),
        fill: white,
        box(
            width: size.width * scale-factor,
            height: size.height * scale-factor,
            scale(scale-factor, content, origin: left + top)
        )
    )

})