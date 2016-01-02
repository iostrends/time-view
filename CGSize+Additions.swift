//
// CGSize+Additions.swift
//
// Convenience properties for CGSize
//
// Created by Richard Clark on 11/12/15.
//
//

import UIKit

public extension CGSize {
    
    func reverse() -> CGSize {
        return CGSize(width: height, height: width)
    }
}
