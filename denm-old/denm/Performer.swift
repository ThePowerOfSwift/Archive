import UIKit
import QuartzCore

/**
Performer
*/
class Performer: StratumContainer {
    
    // MARK: Attributes
    
    /// Performer ID
    var id: String = ""
    
    // MARK: Components
    
    /// All Instruments in Performer
    var instruments: [Instrument] = []
    
    /// Performer Bracket
    var bracket: PerformerBracket?
    
    // MARK: Create a Performer
    
    /**
    Create an empty Performer
    
    :returns: Self: Performer
    */
    override init() {
        super.init()
    }
    
    /**
    Create a Performer with ID
    
    :param: id Performer ID
    
    :returns: Self: Performer
    */
    init(id: String) {
        super.init()
        self.id = id
    }
    
    // MARK: Incrementally build a Performer
    
    /**
    Add Instrument to Performer
    
    :param: instrument Instrument
    
    :returns: Self: Performer
    */
    func addInstrument(instrument: Instrument) -> Performer {
        instruments.append(instrument)
        return self
    }
    
    /**
    Set ID of Performer
    
    :param: id Performer ID
    
    :returns: Self: Performer
    */
    func setID(id: String) -> Performer {
        self.id = id
        return self
    }
    
    /**
    Add and position all necessary components to Performer layer
    
    :returns: Self: Performer
    */
    override func build() -> StratumContainer {
        commitStrata()
        positionStrata()
        //addBracket()
        return self
    }
    
    /**
    Overrides Stratum.positionStrata()
    */
    override func positionStrata() {
        var accumTop: CGFloat = 0
        for stratum in strata {
            accumulateTopPad(&accumTop, stratum: stratum)
            repositionStratum(accumTop, stratum: stratum)
            accumulateHeight(&accumTop, stratum: stratum)
            accumulateBottomPad(&accumTop, stratum: stratum)
        }
        height = accumTop
        setFrame()
        if bracket?.height != 0 { bracket?.resize(top: 0, height: height) }
        if container != nil { container?.positionStrata() }
    }
    
    internal func addBracket() {
        bracket = PerformerBracket()
            .setSize(10) // for testing only
            .setLeft(0)
            .setHeight(height)
            .setTop(0)
            .build()
        addSublayer(bracket)
    }

    override func setExternalPads() {
        externalPads.setBottom(10) // something hard coded?
    }
    
    // FOR TESTING ONLY: KILL ---------------------------------------->
    func addTestInstruments() {
        let amountInstruments: Int = Int(arc4random_uniform(2)) + 1
        println("amount instruments: \(amountInstruments)")
        for _ in 0..<amountInstruments {
            let instrument: Instrument = Instrument()
            instrument.top = 0
            instrument.width = width
            //instrument.borderWidth = 1
            //instrument.borderColor = UIColor.blueColor().CGColor
            //instrument.backgroundColor = UIColor.blueColor().CGColor
            instrument.opacity = 1
            instrument.addTestTrebleClefs()
            //instrument.addTestDynamics()
            instrument.build()
            addInstrument(instrument)
        }
        for instrument in instruments { addStratum(instrument) }
    }
    // <-------------------------------------------------------------- KILL
    
}