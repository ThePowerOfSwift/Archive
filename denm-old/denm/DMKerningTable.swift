import QuartzCore

/**
Checks pair of string characters, and returns percentage of first character that can be cut into
*/
let DMKerningTable: [([String], CGFloat)] = [
    
    // p:
    (["p", "p"], -0.1618),
    (["p", "f"], 0.0),
    (["p", "m"], 0.0),
    (["p", "o"], 0.0),
    (["p", "!"], 0.0),
    (["p", "("], 0.0),
    (["p", ")"], 0.0),
    (["p", "-"], 0.382),
    (["p", "<"], 0.382),
    (["p", ">"], 0.0),
    
    // f:
    (["f", "p"], -0.236),
    (["f", "f"], -0.382),
    (["f", "m"], -0.236),
    (["f", "o"], -0.1236),
    (["f", "!"], 0.0),
    (["f", "("], 0.0),
    (["f", ")"], 0.0),
    (["f", "-"], -0.1236),
    (["f", "<"], 0.0),
    (["f", ">"], 0.0),
    
    // m:
    (["m", "p"], 0.0),
    (["m", "f"], 0.0),
    (["m", "m"], 0.0), // improbable
    (["m", "o"], 0.0), // improbable
    (["m", "!"], 0.0), // improbable
    (["m", "("], 0.0), // improbable
    (["m", ")"], 0.0), // improbable
    (["m", "-"], 0.0), // improbable
    (["m", "<"], 0.0), // improbable
    (["m", ">"], 0.0), // improbable
    
    // o:
    (["o", "p"], 0.0),
    (["o", "f"], 0.0),
    (["o", "m"], 0.0),
    (["o", "o"], 0.236), // improbable
    (["o", "!"], 0.0),
    (["o", "("], 0.0),
    (["o", ")"], 0.0),
    (["o", "-"], 0.382),
    (["o", "<"], 0.382),
    (["o", ">"], 0.0),
    
    // !:
    (["!", "p"], 0.0),
    (["!", "f"], 0.0),
    (["!", "m"], 0.0),
    (["!", "o"], 0.0),
    (["!", "!"], 0.0), // improbable, but fun
    (["!", "("], 0.0),
    (["!", ")"], 0.0),
    (["!", "-"], 0.0), // improbable
    (["!", "<"], 0.0),
    (["!", ">"], 0.0),
    
    // (:
    (["(", "p"], 0.0),
    (["(", "f"], 0.0),
    (["(", "m"], 0.0),
    (["(", "o"], 0.0),
    (["(", "!"], 0.0),
    (["(", "("], 0.0), // improbable
    (["(", ")"], 0.0), // improbable
    (["(", "-"], 0.0), // improbable
    (["(", "<"], 0.0), // improbable
    (["(", ">"], 0.0), // improbable
    
    // ):
    ([")", "p"], 0.0),
    ([")", "f"], 0.0),
    ([")", "m"], 0.0),
    ([")", "o"], 0.0),
    ([")", "!"], 0.0),
    ([")", "("], 0.0), // improbable
    ([")", ")"], 0.0), // improbable
    ([")", "-"], 0.0),
    ([")", "<"], 0.0), // improbable
    ([")", ">"], 0.0), // improbable
    
    // -:
    (["-", "p"], -0.1236),
    (["-", "f"], 0.0),
    (["-", "m"], 0.0),
    (["-", "o"], 0.0),
    (["-", "!"], 0.0),
    (["-", "("], 0.0),
    (["-", ")"], 0.0),
    (["-", "-"], 0.0),
    (["-", "<"], 0.0),
    (["-", ">"], 0.0),

    // <:
    (["<", "p"], -0.1236),
    (["<", "f"], 0.0),
    (["<", "m"], 0.0),
    (["<", "o"], 0.0),
    (["<", "!"], 0.0),
    (["<", "("], 0.0),
    (["<", ")"], 0.0),
    (["<", "-"], 0.0),
    (["<", "<"], 0.0),
    (["<", ">"], 0.0),
    
    // >:
    ([">", "p"], 0.0),
    ([">", "f"], 0.0),
    ([">", "m"], 0.0),
    ([">", "o"], 0.0),
    ([">", "!"], 0.0),
    ([">", "("], 0.0),
    ([">", ")"], 0.0),
    ([">", "-"], 0.0),
    ([">", "<"], 0.0),
    ([">", ">"], 0.0),

]