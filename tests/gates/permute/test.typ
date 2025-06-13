#set page(width: auto, height: auto, margin: 0pt)
#import "/src/quill.typ": *


#quantum-circuit(
  2, permute(1,0), permute(1,0), 1, permute(2,0,1), 2, [\ ],
  2, 4, permute(1,0), 1, [\ ],
  2, gate($H$), 5,
)

#pagebreak()

// Test separation parameter
#quantum-circuit(
  1, 
  permute(1,0, separation: none), 
  permute(1,0, separation: 2pt), 
  permute(1,0, separation: red), 
  1, [\ ],
  5
)

#pagebreak()

// Test bend
#quantum-circuit(
  1, permute(1,0, bend: 0%), 1, [\ ],
  3,
)


#pagebreak()

// Test wire count and stroke
#quantum-circuit(
  setwire(2), 1, permute(1, 0, wire-count: (2, 1)), setwire(1), 1, [\ ], 
  2, setwire(2),
)
#quantum-circuit(
  1, permute(1, 0, wire-count: (1, 2), stroke: (auto, blue)),setwire(2, stroke: blue), [\ ],
  setwire(2, stroke: blue), 2, setwire(1, stroke: black), 1, 
)

// #pagebreak()

// #quantum-circuit(
//   setwire(2), 2, permute(1,3,4,0,2), permute(1,0), 1, permute(2,0,1), 2, [\ ],
//   setwire(2), 2, 4, 1, [\ ],
//   setwire(2), 2, 1, 5, [\ ],
//   setwire(2), 2, 1, 5, [\ ],setwire(2), 
// )
