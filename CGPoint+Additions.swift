//
//  CGPoint+Additions.swift
//  Clock
//
//  Created by Richard Clark on 10/4/15.
//  Copyright © 2015 Richard Clark. All rights reserved.
//

import CoreGraphics

public extension CGPoint {
    
    func distance(to: CGPoint) -> CGFloat {
        let dx = x - to.x
        let dy = y - to.y
        return sqrt(dx * dx + dy * dy);
    }
    
    func scaleBy(scale: CGFloat) -> CGPoint {
        return CGPoint(x: x * scale, y: y * scale)
    }
    
    func add(addend: CGPoint) -> CGPoint {
        return CGPoint(x: x + addend.x, y: y + addend.y)
    }
    
    func subtract(subtrahend: CGPoint) -> CGPoint {
        return CGPoint(x: x - subtrahend.x, y: y - subtrahend.y)
    }
}

