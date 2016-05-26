import UIKit
import QuartzCore

/**
Dynamic Marking: Collection of Dynamic Marking Characters: 

- p
- f
- m
- o
- !
- (
- )

Can be set either by:

- String, with each character therein being converted to a DMCharacter, or
- Int, with numbers < 0 in the (m)p(ppp...) range, and above 0 in the (m)f(fff...) range.

These markings may also be built up gradually, adding Subito or Parenthetical components as desired
*/
class DynamicMarking: StratumObject {
    
    // MARK: Components
    
    /// Array of DMCharacters (Dynamic Marking Character)
    var characters: [DMCharacter] = []
    
    /// String representation of DynamicMarking: more discussion needed
    var string: String = ""
    
    /// Integer representation of DynamicMarking: more discussion needed
    var values: [Int] = []
    
    // MARK: Size
    
    /// Height of Dynamic Marking
    var height: CGFloat = 0
    
    /// Width of Dynamic Marking
    var width: CGFloat = 0
    
    // MARK: Position
    
    /// Horizontal center of Dynamic Marking
    var x: CGFloat = 0
    
    /// Left of Dynamic Marking
    var left: CGFloat = 0
    
    /// Top of Dynamic Marking
    var top: CGFloat = 0
    
    // MARK: Typographical
    
    /// Slant of Dynamic Marking Characters
    var italicAngle: CGFloat = 0
    
    /// Midline of Dynamic Marking Characters
    var midLine: CGFloat = 0
    
    /// xHeight of Dynamic Marking Characters
    var xHeight: CGFloat = 0
    
    /// CapHeight of Dynamic Marking Characters
    var capHeight: CGFloat = 0
    
    /// Baseline of Dynamic Marking Characters
    var baseline: CGFloat = 0
    
    // MARK: Create a Dynamic Marking
    
    override init!() { super.init() }
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Create a Dynamic Marking with String: more discussion needed
    
    :param: string String representation of Dynamic Marking
    
    :returns: Self: DynamicMarking
    */
    init(string: String) {
        super.init()
        self.string = string
        setValuesWithString()
    }
    
    /**
    Create a Dynamic Marking with Integer: more discussion needed
    
    :param: int Integer representation of DMCharacter (Dynamic Marking Character)
    
    :returns: Self: DynamicMarking
    */
    init(int: Int) {
        super.init()
        values = [int]
        string = makeStringWithInt(int)
    }
    
    /**
    Create Dynamic Marking with Array of Integers: more disccusion needed
    
    :param: intSeq Array of Integer representations of DMCharacters (Dynamic Marking Characters)
    
    :returns: Self: DynamicMarking
    */
    init(intSeq: [Int]) {
        super.init()
        values = intSeq
        for i in intSeq { string += makeStringWithInt(i) }
    }
    
    /**
    Create Dynamic Marking with Pair of Integers: more discussion needed
    
    :param: int1 Integer representation of first DMCharacter (Dynamic Marking Character)
    :param: int2 Integer representation of second DMCharacter (Dynamic Marking Character)
    
    :returns: Self: DynamicMarking
    */
    init(int1: Int, int2: Int) {
        super.init()
        values = [int1, int2]
        string += makeStringWithInt(int1) + makeStringWithInt(int2)
    }
    
    // MARK: Incrementally build a DynamicMarking
    
    /**
    Set top
    
    :param: top Top of DynamicMarking
    
    :returns: Self: DynamicMarking
    */
    func setTop(top: CGFloat) -> DynamicMarking {
        self.top = top
        return self
    }
    
    /**
    Set horizontal center of DynamicMarking
    
    :param: x Horizontal center x-value of DynamicMarking
    
    :returns: Self: DynamicMarking
    */
    func setX(x: CGFloat) -> DynamicMarking {
        self.x = x
        return self
    }
    
    /**
    Set Height of DynamicMarking
    
    :param: height Graphical height of DynamicMarking
    
    :returns: Self: DynamicMarking
    */
    func setHeight(height: CGFloat) -> DynamicMarking {
        self.height = height
        return self
    }
    
    /**
    Add Integer representation of DMCharacter (Dynamic Marking Character) to end of Dynamic Marking
    
    :param: int Integer representation of DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func appendInt(int: Int) -> DynamicMarking {
        values.append(int)
        string += makeStringWithInt(int)
        return self
    }
    
    /**
    Add Integer representation of DMCharacter (Dynamic Marking Character) to beginning of Dynamic Marking
    
    :param: int Integer representation of DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func prependInt(int: Int) -> DynamicMarking {
        values.insert(int, atIndex: 0)
        string = makeStringWithInt(int) + string
        return self
    }
    
    /**
    Add Integer representation of parenthetical DMCharacter (Dynamic Marking Character) to end of Dynamic Marking: more discussion needed
    
    :param: int Integer representation of parenthetical DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func appendIntParenthetical(int: Int) -> DynamicMarking {
        values.append(int)
        string += "(" + makeStringWithInt(int) + ")"
        return self
    }
    
    /**
    Add Integer representation of parenthetical DMCharacter (Dynamic Marking Character) to beginning of Dynamic Marking: more discussion needed
    
    :param: int Integer representation of parenthetical DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func prependIntParenthetical(int: Int) -> DynamicMarking {
        values.insert(int, atIndex: 0)
        string = "(" + makeStringWithInt(int) + ")" + string
        return self
    }
    
    /**
    Add Integer representation of subito DMCharacter (Dynamic Marking Character) to end of Dynamic Marking: more discussion needed
    
    :param: int Integer representation of parenthetical DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func appendIntSubito(int: Int) -> DynamicMarking {
        values.append(int)
        string += "!" + makeStringWithInt(int)
        return self
    }
    
    /**
    Add Integer representation of subito DMCharacter (Dynamic Marking Character) to beginning of Dynamic Marking: more discussion needed
    
    :param: int Integer representation of parenthetical DMCharacter
    
    :returns: Self: DynamicMarking
    */
    func prependIntSubito(int: Int) -> DynamicMarking {
        values.insert(int, atIndex: 0)
        string = "!" + makeStringWithInt(int) + string
        return self
    }
    
    /**
    Add all components to DynamicMarking layer
    
    :returns: Self: DynamicMarking
    */
    func build() -> DynamicMarking {
        setCharacterListWithString(string)
        positionCharacters()
        setFrame()
        for c in characters { addSublayer(c) }
        return self
    }
    
    private func makeStringWithInt(int: Int) -> String {
        var string: String = ""
        if int == +0 { string = "o"  }
        if int == +1 { string = "mf" }
        if int == -1 { string = "mp" }
        if int >  +1 { for _ in 0..<(int - 1) { string += "f" } }
        if int <  -1 { for _ in 0..<(abs(int) - 1) { string += "p" } }
        return string
    }
    
    private func setCharacterListWithString(string: String) {
        for c in string {
            let character: DMCharacter = CreateDMCharacter().withID(String(c))!
                .setHeight(height)
                .build()
            characters.append(character)
        }
    }
    
    private func positionCharacters() {
        var accumWidth: CGFloat = 0
        for c in 0..<characters.count {
            let character = characters[c]
            character.position.x = accumWidth + 0.5 * character.width
            accumWidth += character.width
            if c < characters.count - 1 {
                let next: DMCharacter = characters[c + 1]
                let kerning: CGFloat = getKerning(
                    cur: character.kerningKey,
                    next: next.kerningKey
                )
                accumWidth += kerning * character.width
            }
        }
        width = accumWidth
    }
    
    private func getKerning(#cur: String, next: String) -> CGFloat {
        let pair: [String] = [cur, next]
        for (tablePair, kerning) in DMKerningTable { if pair == tablePair { return kerning } }
        return 0.0
    }
    
    private func setValuesWithString() {
        var fCount: Int = 0
        var pCount: Int = 0
        func pDump() { if pCount > 0 { values.append(-(pCount + 1)); pCount = 0 } }
        func fDump() { if fCount > 0 { values.append(+(fCount + 1)); fCount = 0 } }
        func bothDump() {
            if pCount > 0 { values.append(-(pCount + 1)); pCount = 0 }
            if fCount > 0 { values.append(+(fCount + 1)); fCount = 0 }
        }
        var c: Int = 0
        while c < countElements(string) {
            if string[c] == "o" { bothDump(); values.append(Int.min); c++ }
            else if string[c] == "p" { fDump(); pCount++; c++ }
            else if string[c] == "f" { pDump(); fCount++; c++ }
            else if string[c] == "m" { bothDump()
                if string[c + 1] == "f" { values.append(+1); c += 2 }
                else if string[c + 1] == "p" { values.append(-1); c += 2 }
            } else { bothDump(); c++ }
        }
        bothDump()
    }
    
    override func setFrame() {
        left = x - 0.5 * width
        frame = CGRectMake(left, top, width, height)
    }
}