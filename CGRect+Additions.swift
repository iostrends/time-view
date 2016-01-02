//
// CGRect+Additions.swift
//
// Convenience properties for CGRect
//
// Created by Richard Clark on 10/2/15.
//
//

import UIKit
import CoreGraphics

public extension CGRect {
    
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set(x) {
            self = CGRectMake(x, self.origin.y, self.size.width, self.size.height);
        }
    }

    var y: CGFloat {
        get {
            return self.origin.y
        }
        set(y) {
            self = CGRectMake(self.origin.x, y, self.size.width, self.size.height);
        }
    }

    var width: CGFloat {
        get {
            return self.size.width
        }
        set(width) {
            self = CGRectMake(self.origin.x, self.origin.y, width, self.size.height);
        }
    }

    var height: CGFloat {
        get {
            return self.size.height
        }
        set(height) {
            self = CGRectMake(self.origin.x, self.origin.y, self.size.width, height);
        }
    }

    var centerX: CGFloat {
        get {
            return self.origin.x + self.size.width / 2
        }
        set(centerX) {
            self.x = centerX - self.size.width / 2
        }
    }

    var centerY: CGFloat {
        get {
            return self.origin.y + self.size.height / 2
        }
        set(centerY) {
            self.y = centerY - self.size.height / 2
        }
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set(center) {
            centerX = center.x
            centerY = center.y
        }
    }
    
    var centerRelative: CGPoint {
        get {
            return CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        }
    }
    
    var rightX: CGFloat {
        get {
            return self.x + self.width
        }
        set(rightX) {
            self.x = rightX - self.width;
        }
    }
    
    var bottomY: CGFloat {
        get {
            return self.y + self.height
        }
        set(bottomY) {
            self.y = bottomY - self.height;
        }
    }
    
    var topLeftCorner: CGPoint {
        get {
            return CGPoint(x: self.x, y: self.y)
        }
    }
    
    var topRightCorner: CGPoint {
        get {
            return CGPoint(x: self.rightX, y: self.y)
        }
    }
    
    var bottomLeftCorner: CGPoint {
        get {
            return CGPoint(x: self.x, y: self.bottomY)
        }
    }
    
    var bottomRightCorner: CGPoint {
        get {
            return CGPoint(x: self.rightX, y: self.bottomY)
        }
    }
    
    var flipped: CGRect {
        get {
            return CGRect(x: y, y: x, width: height, height: width)
        }
    }
    
    func outsideDistanceTo(point: CGPoint) -> CGFloat {
        var dist: CGFloat = 0
        if point.x < x {
            // Left three sectors
            if point.y < y {
                dist = point.distance(topLeftCorner)
            } else if point.y < bottomY {
                dist = x - point.x
            } else {
                dist = point.distance(bottomLeftCorner)
            }
        } else if point.x < rightX {
            // Middle three sectors
            if point.y < y {
                dist = y - point.y
            } else if point.y < bottomY {
                // Inside the rect
                dist = 0
            } else {
                dist = point.y - bottomY
            }
        } else {
            // Right three sectors
            if point.y < y {
                dist = point.distance(topRightCorner)
            } else if point.y < bottomY {
                dist = point.x - rightX
            } else {
                dist = point.distance(bottomRightCorner)
            }
        }
        return dist
    }
    
    func shrinkBy(inset: CGFloat) -> CGRect {
        return CGRect(x: x + inset, y: y + inset, width: width - 2 * inset, height: height - 2 * inset)
    }
    
    func shrinkBy(edgeInsets: UIEdgeInsets) -> CGRect {
        let newX: CGFloat = x + edgeInsets.left
        let newY: CGFloat = y + edgeInsets.top
        let newWidth: CGFloat = width - edgeInsets.right - edgeInsets.left
        let newHeight: CGFloat = height - edgeInsets.bottom - edgeInsets.left
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}
