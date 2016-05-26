import QuartzCore

class PadHorizontal: GraphicalPad {

    init(width: CGFloat) {
        super.init()
        self.width = width
        setFrame()
    }
}