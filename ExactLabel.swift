//
//  ExactLabel.swift
//  UIView that sizes itself to the exact width of the string glyph plus left and right insets.
//
//  Created by Richard Clark on 12/30/15.
//  Copyright © 2015 Richard Clark. All rights reserved.
//

import UIKit
import CoreGraphics

class ExactLabel: UIView {

    var leftRightMargin: CGFloat = 1 {
        didSet {
            sizeToFit()
            setNeedsDisplay()
        }
    }
    
    var font = UIFont.systemFontOfSize(10) {
        didSet {
            sizeToFit()
            setNeedsDisplay()
        }
    }
    
    var text = "" {
        didSet {
            sizeToFit()
            setNeedsDisplay()
        }
    }
    
    var textColor = UIColor.blackColor()
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let context = UIGraphicsGetCurrentContext()
        let attrString = NSAttributedString(string: text, attributes: [NSFontAttributeName:font])
        let selStringLineRef = CTLineCreateWithAttributedString(attrString)
        let textGlyphRect = CTLineGetImageBounds(selStringLineRef, context)
        let width = textGlyphRect.width + 2 * leftRightMargin
        let height = font.lineHeight
        return CGSize(width: width, height: height)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        backgroundColor?.setFill()
        UIRectFill(rect)
        let attrString = NSAttributedString(string: text, attributes: [NSFontAttributeName:font])
        let selStringLineRef = CTLineCreateWithAttributedString(attrString)
        let lineWidth = CGFloat(CTLineGetTypographicBounds(selStringLineRef, nil, nil, nil))
        let textGlyphRect = CTLineGetImageBounds(selStringLineRef, context)
        let textDrawRect = CGRectMake(round(-textGlyphRect.x) + leftRightMargin, 0, lineWidth, font.lineHeight);
        let attributes = [ NSFontAttributeName: font, NSForegroundColorAttributeName: textColor ]
        text.drawInRect(textDrawRect, withAttributes: attributes)
    }
}
