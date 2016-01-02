//
//  UILabel+Additions.swift
//  TestClockFaceEditor
//
//  Created by Richard Clark on 11/13/15.
//  Copyright © 2015 Richard Clark. All rights reserved.
//

import UIKit

public extension UILabel {
    var glyphInsets: UIEdgeInsets {
        get {
            if let text = text {
                let glyphRect = text.boundingRect(font)
                let left = glyphRect.x
                let top = glyphRect.y
                let right = width - glyphRect.rightX
                let bottom = height - glyphRect.bottomY
                return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            } else {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
}

