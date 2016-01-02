//
//  NSString+Additions.swift
//  TestClockFaceEditor
//
//  Created by Richard Clark on 10/22/15.
//  Copyright © 2015 Richard Clark. All rights reserved.
//

import UIKit

public extension String {

    func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
    func endsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str, options:NSStringCompareOptions.BackwardsSearch) {
            return range.endIndex == self.endIndex
        }
        return false
    }

    static func stringFromImageOrientation(orientation: UIImageOrientation) -> String {
        switch orientation {
        case .Up:
            return "Up"
        case .Down:
            return "Down"
        case .Left:
            return "Left"
        case .Right:
            return "Right"
        case .UpMirrored:
            return "UpMirrored"
        case .DownMirrored:
            return "DownMirrored"
        case .LeftMirrored:
            return "LeftMirrored"
        case .RightMirrored:
            return "RightMirrored"
        }
    }

    func boundingRect(font: UIFont) -> CGRect {
        let context = UIGraphicsGetCurrentContext()
        let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName:font])
        let selStringLineRef = CTLineCreateWithAttributedString(attrString)
        let textGlyphRect = CTLineGetImageBounds(selStringLineRef, context)
        return textGlyphRect
    }

    func typographicWidth(font: UIFont) -> CGFloat {
        let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName:font])
        let selStringLineRef = CTLineCreateWithAttributedString(attrString)
        let typoWidth = CTLineGetTypographicBounds(selStringLineRef, nil, nil, nil)
        return CGFloat(typoWidth)
    }
}
