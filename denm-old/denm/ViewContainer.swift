import UIKit

class ViewContainer: ViewNode {
    
    /// ViewNodes container by ViewContainer
    var objects: [ViewNode] = []
    
    /// The direction to which objects flow vertically (.Top, .Bottom, .Center, .Justify)
    var flow_vertical: ViewContainerFlowVertical = ViewContainerFlowVertical.Top

    /// The direction to which objects flow horizontally (.Left, .Right, .Center, .Justify)
    var flow_horizontal: ViewContainerFlowHorizontal = ViewContainerFlowHorizontal.Left
    
    /// The order in which objects are positioned (.VerticalHorizontal, .HorizontalVertical)
    var flowOrder: ViewContainerFlowOrder = ViewContainerFlowOrder.VerticalHorizontal
    
    // CALayer Init ===========================================================================
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init!() { super.init() }
    override init!(layer: AnyObject) { super.init(layer: layer) }
    
    /**
    Add object to ViewContainer
    
    :param: object Object to be added to VieWContainer
    */
    func addObject(object: ViewNode) {
        objects.append(object)
        // add to view
        // position
        // set container
    }
    
    /**
    Remove object from ViewContainer
    
    :param: object Object to be removed
    */
    func removeObject(object: ViewNode) {
        objects.removeObject(object)
        // remove from view as well: object.removeFromSuperlayer()?
        positionObjects()
    }
    
    /**
    Position all objects according the flow rules declared
    */
    func positionObjects() {
        // switch by flow direction and order
        
        // accumulated pads, margins, etc
    }
    
    /**
    Insert object after object
    
    :param: object       The object to be inserted
    :param: objectBefore The object to be before the one insert
    */
    func insertObject(object: ViewNode, afterObject objectBefore: ViewNode) {
        let index: Int = getIndexOfObject(objectBefore)! + 1
        objects.insert(object, atIndex: index)
        positionObjects()
    }
    
    /**
    Insert object before object
    
    :param: object      The object to be inserted
    :param: objectAfter The object to be after the one inserted
    */
    func insertObject(object: ViewNode, beforeObject objectAfter: ViewNode) {
        let index: Int = getIndexOfObject(objectAfter)!
        objects.insert(object, atIndex: index)
        positionObjects()
    }
    
    /**
    Get object before object
    
    :param: object The object after the one you want
    
    :returns: The object you want
    */
    func getObjectBeforeObject(object: ViewNode) -> ViewNode? {
        let index: Int = getIndexOfObject(object)!
        return objects[index - 1]
    }
    
    /**
    Get object after object
    
    :param: object The object before the one you want
    
    :returns: The object you want
    */
    func getObjectAfterObject(object: ViewNode) -> ViewNode? {
        let index: Int = getIndexOfObject(object)!
        return objects[index - 1]
    }
    
    private func getIndexOfObject(object: ViewNode) -> Int? {
        var index: Int?
        for (i, o) in enumerate(objects) { if o === object { index = i; break } }
        return index
    }
}