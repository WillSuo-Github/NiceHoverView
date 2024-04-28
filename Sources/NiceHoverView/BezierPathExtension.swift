//
//  BezierPathExtension.swift
//
//
//  Created by will Suo on 2024/4/27.
//

import AppKit

internal extension NSBezierPath {
    func cgPath() -> CGPath {
        let path = CGMutablePath()
        let numElements = self.elementCount
        let points = NSPointArray.allocate(capacity: 3)
        
        for i in 0 ..< numElements {
            let elementType = self.element(at: i, associatedPoints: points)
            let cgPoints = [points[0], points[1], points[2]].map { CGPoint(x: $0.x, y: $0.y) }
            
            switch elementType {
            case .moveTo:
                path.move(to: cgPoints[0])
            case .lineTo:
                path.addLine(to: cgPoints[0])
            case .curveTo:
                path.addCurve(to: cgPoints[2], control1: cgPoints[0], control2: cgPoints[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }
}
