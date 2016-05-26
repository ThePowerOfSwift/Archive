import QuartzCore

class PadVertical: GraphicalPad {
    
    init(height: CGFloat) {
        super.init()
        self.height = height
        setFrame()
    }
}