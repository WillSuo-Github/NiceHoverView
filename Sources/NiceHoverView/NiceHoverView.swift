import AppKit

open class NiceHoverView: NSView {
    open var isMouseIn: Bool = false
    
    private var trackingArea: NSTrackingArea?
    
    private lazy var hoverLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let rect = hoverRect()
        let bezierPath = NSBezierPath(roundedRect: rect, xRadius: xRadius(), yRadius: yRadius())
        layer.path = bezierPath.cgPath()
        return layer
    }()
    
    open override func mouseEntered(with event: NSEvent) {
        isMouseIn = true
        showHoverLayer(with: event)
    }
    
    open override func mouseExited(with event: NSEvent) {
        isMouseIn = false
        hideHoverLayer(with: event)
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
        return 20
    }
    
    open func yRadius() -> CGFloat {
        return 20
    }
    
    private func triggerMouseExit() {
        guard let window = window,
              let currentEvent = NSApplication.shared.currentEvent else { return }
        let screenPoint = NSEvent.mouseLocation
        let screenRect = CGRect(origin: screenPoint, size: CGSize(width: 1, height: 1))
        let windowRect = window.convertFromScreen(screenRect)
        let pointInView = convert(windowRect.origin, from: nil)
        let rectInView = CGRect(origin: pointInView, size: CGSize(width: 1.0, height: 1.0))
        if CGRectContainsRect(bounds, rectInView) {
            //            mouseDidEntered(with: currentEvent)
        } else {
            mouseExited(with: currentEvent)
        }
    }
}

// MARK: - Draw
extension NiceHoverView {
    private func showHoverLayer(with event: NSEvent) {
        let location = event.locationInWindow
        let entryPoint = convert(location, from: nil)
        
        if hoverLayer.superlayer == nil {
            layer?.addSublayer(hoverLayer)
        }
        
        removeAllHoverLayerAnimations()
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let deltaX = (centerPoint.x - entryPoint.x) / 2
        let deltaY = (centerPoint.y - entryPoint.y) / 2
        
        hoverLayer.position = CGPoint(x: -deltaX, y: -deltaY)
        
        let positionAnimation = CASpringAnimation(keyPath: "position")
        positionAnimation.toValue = NSValue(point: CGPoint.zero)
        positionAnimation.damping = 15
        positionAnimation.initialVelocity = 10
        positionAnimation.stiffness = 100
        positionAnimation.mass = 1
        positionAnimation.duration = positionAnimation.settlingDuration
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        
        hoverLayer.add(positionAnimation, forKey: "position")
    }
    
    private func hideHoverLayer(with event: NSEvent) {
        let location = event.locationInWindow
        let exitPoint = convert(location, from: nil)

        if hoverLayer.superlayer != nil {
            removeAllHoverLayerAnimations()

            let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
            let deltaX = (exitPoint.x - centerPoint.x) / 5
            let deltaY = (exitPoint.y - centerPoint.y) / 5

            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.1
            animationGroup.fillMode = .forwards
            animationGroup.isRemovedOnCompletion = false
            animationGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)

            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = NSValue(point: CGPoint.zero)
            positionAnimation.toValue = NSValue(point: CGPoint(x: deltaX, y: deltaY))

            let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
            fadeOutAnimation.fromValue = 1.0
            fadeOutAnimation.toValue = 0.0

            animationGroup.delegate = self
            animationGroup.animations = [positionAnimation, fadeOutAnimation]

            hoverLayer.add(animationGroup, forKey: "fadeOut")
        }
    }

    
    private func removeAllHoverLayerAnimations() {
        hoverLayer.removeAllAnimations()
    }
}

// MARK: - Tracking Area
extension NiceHoverView {
    public override func updateTrackingAreas() {
        if let tracking = trackingArea {
            removeTrackingArea(tracking)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let newTracking = NSTrackingArea(rect: bounds, options: options, owner: self)
        addTrackingArea(newTracking)
        trackingArea = newTracking
        triggerMouseExit()
    }
}

// MARK: - CAAnimationDelegate
extension NiceHoverView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag { // 确保动画是自然完成的
            hoverLayer.removeFromSuperlayer()
        }
    }
}
