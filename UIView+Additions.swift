//
// UIView+Frame.swift
//
// Convenience properties for UIView frame geometry
//
// Created by Richard Clark on 8/9/15.
//
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            self.center = CGPointMake(centerX, self.center.y);
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(centerY) {
            self.center = CGPointMake(self.center.x, centerY);
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
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(origin) {
            self.frame.origin = origin
        }
    }
    
    var centerRelative: CGPoint {
        get {
            return CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(size) {
            self.frame.size = size
        }
    }

    func imageSnapshot() -> UIImage {
        let scaledBounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        UIGraphicsBeginImageContextWithOptions(scaledBounds.size, true, contentScaleFactor)
        if let context = UIGraphicsGetCurrentContext() {
            layer.renderInContext(context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
