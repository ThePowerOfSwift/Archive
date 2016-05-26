import UIKit
import QuartzCore

/**
Graph Info Layer: Contains all musical info of Graph
*/
class GraphInfoLayer: CALayer {

    // MARK: Components
    
    /// All components in GraphInfoLayer
    var components: [CALayer] = []
    
    /// All articulations in GraphInfoLayer
    var articulations: [Articulation] = []
    
    var slurs: [Slur] = []
    
    // MARK: Create a GraphInfoLayer
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: Incrementally build a GraphInfoLayer
    
    /**
    Add articulation to GraphInfoLayer
    
    :param: articulation Articulation for GraphEvent on GraphInfoLayer
    
    :returns: Self: GraphInfoLayer
    */
    func addArticulation(articulation: Articulation) -> GraphInfoLayer {
        articulations.append(articulation)
        return self
    }
    
    func addSlur(slur: Slur) -> GraphInfoLayer {
        slurs.append(slur)
        return self
    }
    
    /**
    Add all necessary components to GraphInfoLayer
    
    :returns: Self: GraphInfoLayer
    */
    func build() -> GraphInfoLayer {
        commitComponents()
        addComponents()
        return self
    }
    
    internal func commitComponent(component: CALayer) {
        components.append(component)
    }
    
    internal func addComponents() {
        for component in components { addSublayer(component) }
    }
    
    internal func commitComponents() {
        
    }
    
    internal func commitArticulations() {
        for articulation in articulations { components.append(articulation) }
    }
}