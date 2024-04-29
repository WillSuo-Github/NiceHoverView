//
//  File.swift
//  
//
//  Created by will Suo on 2024/4/29.
//

import AppKit

open class NiceHoverTableCellView: NSTableCellView {
    public lazy var hoverHelper = HoverHelper(hoverLayer: hoverLayer)
    
    private lazy var hoverLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let rect = hoverRect()
        let bezierPath = NSBezierPath(roundedRect: rect, xRadius: xRadius(), yRadius: yRadius())
        layer.path = bezierPath.cgPath()
        return layer
    }()
    
    open override func mouseEntered(with event: NSEvent) {
        hoverHelper.showHoverLayer(with: event, onView: self)
    }
    
    open override func mouseExited(with event: NSEvent) {
        hoverHelper.hideHoverLayer(with: event, onView: self)
    }
    
    open override func updateLayer() {
        super.updateLayer()
        
        hoverLayer.fillColor = hoverColor().cgColor
    }
    
    open func hoverColor() -> NSColor {
        return NSColor(white: 0, alpha: 0.1)
    }
    
    open func hoverRect() -> NSRect {
        return bounds
    }
    
    open func xRadius() -> CGFloat {
        return 6
    }
    
    open func yRadius() -> CGFloat {
        return 6
    }
}

// MARK: - HoverProtocol
extension NiceHoverTableCellView: HoverProtocol { }

// MARK: - Tracking Area
extension NiceHoverTableCellView {
    public override func updateTrackingAreas() {
        if let tracking = hoverHelper.trackingArea {
            removeTrackingArea(tracking)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let newTracking = NSTrackingArea(rect: bounds, options: options, owner: self)
        addTrackingArea(newTracking)
        hoverHelper.trackingArea = newTracking
        hoverHelper.triggerMouseExit(onView: self)
    }
}
