//
//  File.swift
//  
//
//  Created by will Suo on 2024/4/29.
//

import AppKit

open class NiceHoverButton: NSButton {
    public lazy var hoverHelper = HoverHelper(hoverLayer: hoverLayer)
    
    private lazy var hoverLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    open override func mouseEntered(with event: NSEvent) {
        updateHoverColor()
        hoverHelper.showHoverLayer(with: event, onView: self, useAnimation: useAnimation())
    }
    
    open override func mouseExited(with event: NSEvent) {
        updateHoverColor()
        hoverHelper.hideHoverLayer(with: event, onView: self, useAnimation: useAnimation())
    }
    
    open override func updateLayer() {
        super.updateLayer()
        updateHoverColor()
    }
    
    open override func layout() {
        super.layout()
        
        let rect = hoverRect()
        let bezierPath = NSBezierPath(roundedRect: rect, xRadius: xRadius(), yRadius: yRadius())
        hoverLayer.path = bezierPath.cgPath()
    }
    
    private func updateHoverColor() {
        NSApplication.shared.effectiveAppearance.performAsCurrentDrawingAppearance {
            hoverLayer.fillColor = hoverColor().cgColor
        }
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
    
    open func useAnimation() -> Bool {
        return true
    }
}

// MARK: - HoverProtocol
extension NiceHoverButton: HoverProtocol { }

// MARK: - Tracking Area
extension NiceHoverButton {
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

