import QuartzCore

class GraphicalPad {
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    
    init() {}
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        setFrame()
    }
    
    func setHeight(height: CGFloat) -> GraphicalPad {
        self.height = height
        setFrame()
        return self
    }
    
    func setWidth(width: CGFloat) -> GraphicalPad {
        self.width = width
        setFrame()
        return self
    }
    
    func setFrame() {
        frame = CGRectMake(0, 0, width, height)
    }
}