import UIKit
import QuartzCore

/**
Instrument
*/
class Instrument: StratumContainer {
    
    // MARK: Attributes
    
    /// Instrument ID
    var id: String = ""
   
    // MARK: Components
    
    /// All Graphs in Instrument
    var graphs: [Graph] = []
    
    // MARK: Create an Instrument
    
    /**
    Create an empty Instrument
    
    :returns: Self: Instrument
    */
    override init() {
        super.init()
    }
    
    /**
    Create an Instrument with ID
    
    :param: id Instrument ID
    
    :returns: Self: Instrument
    */
    init(id: String) {
        super.init()
        self.id = id
    }

    // MARK: Incrementally build an Instrument
    
    /**
    Set ID of Instrument
    
    :param: id Instrument ID
    
    :returns: Self: Instrument
    */
    func setID(id: String) -> Instrument {
        self.id = id
        return self
    }
    
    /**
    Add Graph to Instrument
    
    :param: graph Graph
    
    :returns: Self: Instrument
    */
    func addGraph(graph: Graph) -> Instrument {
        graphs.append(graph)
        return self
    }
    
    // FOR TESTING ONLY: KILL ---------------------------------------->
    func addTestTrebleClefs() {
        let amountStaves: Int = Int(arc4random_uniform(2)) + 1
        for _ in 0..<amountStaves {
            let staff: Staff = Staff()
                .setSize(g: 10)
                .setTop(100)
                
                .addClef("treble", x: 25)
                
                .startNewEventAt(75)
                
                .startNewEventAt(200)
                
                .startNewEventAt(300)
                
                .addClef("bass", x: 350)
                
                .startNewEventAt(400)
                
                .startNewEventAt(500)
                
                .startNewEventAt(550)
                
                .stopStaffLinesAt(x: 600)
                .build()
            addGraph(staff)
        }
        for graph in graphs { addStratum(graph) }
    }
    // <-------------------------------------------------------------- KILL
    
    // FOR TESTING ONLY: KILL ---------------------------------------->
    func addTestGraphs() {
        let amountGraphs: Int = Int(arc4random_uniform(2)) + 1
        for _ in 0..<amountGraphs {
            let graph: Graph = Graph()
            graph.width = width
            //graph.borderWidth = 1
            //graph.borderColor = UIColor.greenColor().CGColor
            //graph.backgroundColor = UIColor.greenColor().CGColor
            graph.opacity = 1
            graph.build()
            addGraph(graph)
        }
        for graph in graphs { addStratum(graph) }
    }
    // <-------------------------------------------------------------- KILL
    
    // FOR TESTING ONLY: KILL ---------------------------------------->
    func randomClefType() -> String {
        let clefs: [String] = ["bass", "tenor", "alto", "treble"]
        let randChoice: Int = Int(arc4random_uniform(UInt32(clefs.count)))
        let clefType = clefs[randChoice]
        return clefType
    }
    // <-------------------------------------------------------------- KILL
    
    // FOR TESTING ONLY: KILL ---------------------------------------->
    func addTestDynamics() -> Instrument {
        let dmStratum: DMStratum = DMStratum()
            .setHeight(20)
            .setTop(0)
            .addDynamicMarking(DynamicMarking(string:"ffffo"), x: 200)
            .addInterpolationHairpin()
            .addDynamicMarking(DynamicMarking(string: "pppppfo"), x: 700)
            .build()
        addStratum(dmStratum)
        return self
    }
    
    override func setExternalPads() {
        externalPads.setBottom(10)
    }
}