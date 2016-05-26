//
//  ComponentSelectorTableViewHeaderButton.swift
//  DNM_iOS
//
//  Created by James Bean on 12/16/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class ComponentSelectorTableViewHeaderButton: UIButton {
    
    public var model: ComponentSelectorTableViewHeaderModel!
    
    public var delegate: ComponentSelectorTableViewHeaderButtonDelegate?
    
    public init(model: ComponentSelectorTableViewHeaderModel, frame: CGRect) {
        self.model = model
        super.init(frame: frame)
        updateView()
        addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchUpInside)
        addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchDragEnter)
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func pressed() {
        switchState()
        delegate?.didPressHeaderButton(self)
    }
    
    private func switchState() {
        model.hit()
        updateView()
    }
    
    private func switchOn() {
        model.state = .On
        updateView()
    }
    
    private func switchOff() {
        model.state = .Off
        updateView()
    }
    
    private func updateView() {
        setTitle(model.text, forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        switch model.state {
        case .On:
            backgroundColor = UIColor.greenColor()
            setTitleColor(UIColor.whiteColor(), forState: .Normal)
        case .Off:
            backgroundColor = UIColor.redColor()
            setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        case .MultipleValues:
            backgroundColor = UIColor.whiteColor()
            setTitleColor(UIColor.redColor(), forState: .Normal)
        }
    }
}

