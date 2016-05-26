import QuartzCore

struct ExternalPads {
    var top: GraphicalPad = PadVertical(height: 0)
    var left: GraphicalPad = PadHorizontal(width: 0)
    var right: GraphicalPad = PadHorizontal(width: 0)
    var bottom: GraphicalPad = PadVertical(height: 0)
    
    func setTop(height: CGFloat) { top.height = height }
    func setLeft(width: CGFloat) { left.width = width }
    func setRight(width: CGFloat) { right.width = width }
    func setBottom(height: CGFloat) { bottom.height = height }
    
    func getTop() -> CGFloat { return top.height }
    func getLeft() -> CGFloat { return left.width }
    func getRight() -> CGFloat { return right.width }
    func getBottom() -> CGFloat { return bottom.height }
}