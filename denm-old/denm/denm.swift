import Foundation

class denm {
    
    var code: String
    
    init(filePath: String) {
        
        println("filePath: \(filePath)")
        
        self.code = String(
            contentsOfFile: filePath,
            encoding: NSUTF8StringEncoding,
            error: nil
        )!
    }
    
    func getSpanTreesAndMeasures() -> ([SpanTree],[Measure]) {
        
        let beforeScanner: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        
        // do things
        let scanner = Scanner(code: code)
        let items = scanner.getItems()
        
        let afterScanner: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        
        let scannerTime = afterScanner - beforeScanner
        println("Scanner Time: \(scannerTime)")
        
        let beforeTokenizer: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        // more things
        let tokenizer = Tokenizer(items: items)
        let tokens = tokenizer.getTokens()
        let afterTokenizer = CFAbsoluteTimeGetCurrent()
        println("Tokenizer Time: \(afterTokenizer - beforeTokenizer)")
        
        let beforeParser = CFAbsoluteTimeGetCurrent()
        // more things
        let parser = Parser(tokens: tokens)
        let actions = parser.getActions()
        let afterParser = CFAbsoluteTimeGetCurrent()
        println("Parser Time: \(afterParser - beforeParser)")
        
        let beforeInterpreter = CFAbsoluteTimeGetCurrent()
        // Generate Score from Actions
        let interpreter = Interpreter(actions: actions)
        let (spanTrees, measures) = interpreter.generate()
        let afterInterpreter = CFAbsoluteTimeGetCurrent()
        println("Interpreter Time: \(afterInterpreter - beforeInterpreter)")
        return (spanTrees, measures)
    }
}