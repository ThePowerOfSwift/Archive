import UIKit

extension CALayer {

    func printToPDF() {
        
        println("CALayer.printToPDF: \(self)")
        
        let padding: CGFloat = 20
        //let pageFrame = CGRectMake(0, 0, bounds.maxX + 2 * padding, bounds.maxY + 2 * padding)
        
        let pageFrame = CGRectMake(0, 0, 612, 792)
        UIGraphicsBeginPDFContextToFile("/Users/BEAN/testFile.pdf", pageFrame, nil)
        UIGraphicsBeginPDFPage()
        
        /*
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        */

        var context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, padding, padding)
        traverseToPrintToPDF(self, context: context)
        UIGraphicsEndPDFContext()
    }
    
    private func traverseToPrintToPDF(layer: CALayer, context: CGContextRef) {
        
        println("traverseToPrintPDF: \(layer)")
        CGContextTranslateCTM(context, layer.frame.minX, layer.frame.minY)
        if let shapeLayer = layer as? CAShapeLayer {
            printShapeLayerToPDF(shapeLayer, context: context)
        }
        else {
            if layer.sublayers != nil {
                
                for sublayer in layer.sublayers! {
                    traverseToPrintToPDF(sublayer as CALayer, context: context)
                }
            }
        }
    }
    
    private func printShapeLayerToPDF(shapeLayer: CAShapeLayer, context: CGContextRef) {
        
        // somehow parse CATransform3D of shapeLayer, convert to CGAffineTransformRotate
        
        println("printShapeLayerToPDF: \(shapeLayer)")
        CGContextTranslateCTM(context, shapeLayer.frame.minX, shapeLayer.frame.minY)
        
        /*
        if shapeLayer.transform === CATransform3DIdentity {
            println("shapeLayer.transform == IDENTITY")
        }
        else {
            
        }
        */
        
        CGContextAddPath(context, shapeLayer.path)
        CGContextSetFillColorWithColor(context, shapeLayer.fillColor)
        CGContextSetLineWidth(context, shapeLayer.lineWidth)
        CGContextSetStrokeColorWithColor(context, shapeLayer.strokeColor)
        CGContextDrawPath(context, kCGPathEOFillStroke)
        
        // undo translation
        CGContextTranslateCTM(context, -shapeLayer.frame.minX, -shapeLayer.frame.minY)
    }
}