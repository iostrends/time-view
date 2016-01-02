//
//  InsetLabel.swift
//  TimeViewDemo
//
//  Created by Richard Clark on 1/1/16.
//  Copyright © 2016 Richard Clark. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    
    var insets = UIEdgeInsetsZero
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let newSize = super.sizeThatFits(size)
        return CGSizeMake(newSize.width + insets.left + insets.right, newSize.height + insets.top + insets.bottom)
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
