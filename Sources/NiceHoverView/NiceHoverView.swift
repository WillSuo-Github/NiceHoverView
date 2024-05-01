import AppKit

open class NiceHoverView: NSView {
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
    
    open override func layout() {
        super.layout()
        
        let rect = hoverRect()
        let bezierPath = NSBezierPath(roundedRect: rect, xRadius: xRadius(), yRadius: yRadius())
        hoverLayer.path = bezierPath.cgPath()
    }
    
    open override func updateLayer() {
        super.updateLayer()
        updateHoverColor()
    }
    
    private func updateHoverColor() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
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
        return 20
    }
    
    open func yRadius() -> CGFloat {
        return 20
    }
    
    open func useAnimation() -> Bool {
        return true
    }
}

// MARK: - HoverProtocol
extension NiceHoverView: HoverProtocol { }

// MARK: - Tracking Area
extension NiceHoverView {
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

