//
//  ComponentSelectorTableViewCell.swift
//  DNM_iOS
//
//  Created by James Bean on 12/15/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

public class ComponentSelectorTableViewCell: UITableViewCell {

    public var model: ComponentSelectorTableViewCellModel!
    
    // TODO: manage view with model
    public init(model: ComponentSelectorTableViewCellModel) {
        self.model = model
        
        // this is temporary, figure out how to deal with NSCoder...
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func goToNextState() {
        model.goToNextState()
        updateView()
    }
    
    public func mute() {
        model.mute()
        updateView()
    }
    
    public func unmute() {
        model.unmute()
        updateView()
    }
    
    public func updateView() {

        // manage text
        textLabel!.text = model.text
        
        switch model.state {
        case .On:
            textLabel!.textColor = UIColor.whiteColor()
            backgroundColor = UIColor.greenColor()
        case .Off:
            textLabel!.textColor = UIColor.whiteColor()
            backgroundColor = UIColor.redColor()
        case .Muted:
            textLabel!.textColor = UIColor.whiteColor()
            backgroundColor = UIColor.lightGrayColor()
        case .MultipleValues:
            textLabel!.textColor = UIColor.redColor()
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


