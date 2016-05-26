//
//  UITableViewExtensions.swift
//  DNM_iOS
//
//  Created by James Bean on 12/17/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func resizeToFitContents() {
        let contentsHeight = contentSize.height
        var newFrame = frame
        newFrame.size.height = contentsHeight
        frame = newFrame
    }
}