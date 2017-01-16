//
//  ViewController.swift
//  LayoutToolsDemo-iOS
//
//  Created by James Bean on 7/21/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit
import TreeTools
import LayoutTools

class ViewController: UIViewController {

    var root: LayoutNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rootLayer = CALayer()
        rootLayer.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 0))
        rootLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        root = LayoutNode(rootLayer,
            stackingHorizontallyFrom: .right,
            aligningVerticallyTo: .bottom
        )
        
        let amountChildren = 3
        for _ in 0 ..< amountChildren {
            
            let childLayer = CALayer()
            childLayer.backgroundColor = UIColor.blueColor().CGColor
            childLayer.borderColor = UIColor.orangeColor().CGColor
            childLayer.borderWidth = 1
            let child = LayoutNode(childLayer,
                stackingVerticallyFrom: .top,
                aligningHorizontallyTo: .right
            )
            child.padding = LayoutNode.Padding(5)
            
            let amountGrandchildren = 3
            for _ in 0 ..< amountGrandchildren {
                let width = CGFloat((arc4random() % 100) + 10)
                let height = CGFloat((arc4random() % 100) + 10)
                let layer = CALayer()
                layer.frame = CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(width: width, height: height)
                )
                layer.backgroundColor = UIColor.greenColor().CGColor
                layer.borderColor = UIColor.purpleColor().CGColor
                layer.borderWidth = 1
                let node = LayoutNode(layer)
                node.padding = LayoutNode.Padding(5)
                child.addChild(node)
            }
            child.layout()
            root.addChild(child)
        }
        
        root.layout()
        view.layer.addSublayer(rootLayer)
    }
    
    @IBAction func insertNodeButtonPressed(sender: UIButton) {
        insertNode()
    }
    
    func insertNode() {
        let layer = CALayer()
        let width = CGFloat((arc4random() % 100) + 10)
        let height = CGFloat((arc4random() % 1000) + 10)
        layer.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        layer.backgroundColor = UIColor.yellowColor().CGColor
        let node = LayoutNode(layer)
        node.padding = LayoutNode.Padding(20)
        try! root.insertChild(node, at: 1)
        node.layout(animated: true)
        root.layout(animated: true)
    }
}

