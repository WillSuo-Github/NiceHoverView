//
//  HoverHelper.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/28.
//

import AppKit

open class HoverHelper: NSObject {
    var isMouseIn: Bool = false
    
    var hoverLayer: CAShapeLayer
    
    var trackingArea: NSTrackingArea?
    
    init(hoverLayer: CAShapeLayer) {
        self.hoverLayer = hoverLayer
        super.init()
    }
    
    func showHoverLayer(with event: NSEvent, onView: NSView) {
        guard isMouseIn == false else { return }
        
        isMouseIn = true
        let location = event.locationInWindow
        let entryPoint = onView.convert(location, from: nil)
        
        if hoverLayer.superlayer == nil {
            onView.wantsLayer = true
            onView.layer?.addSublayer(hoverLayer)
        }
        
        removeAllHoverLayerAnimations(hoverLayer: hoverLayer)
        
        let centerPoint = CGPoint(x: onView.bounds.midX, y: onView.bounds.midY)
        let rawDeltaX = (centerPoint.x - entryPoint.x) / 2
        let rawDeltaY = (centerPoint.y - entryPoint.y) / 2
        
        let deltaX = max(-10, min(10, rawDeltaX))
        let deltaY = max(-10, min(10, rawDeltaY))
        
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
    
    func hideHoverLayer(with event: NSEvent, onView: NSView) {
        guard isMouseIn else { return }
        
        isMouseIn = false
        let location = event.locationInWindow
        let exitPoint = onView.convert(location, from: nil)
        
        if hoverLayer.superlayer != nil {
            removeAllHoverLayerAnimations(hoverLayer: hoverLayer)
            
            let centerPoint = CGPoint(x: onView.bounds.midX, y: onView.bounds.midY)
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
    
    func triggerMouseExit(onView: NSView) {
        guard let window = onView.window,
              let currentEvent = NSApplication.shared.currentEvent else { return }
        let screenPoint = NSEvent.mouseLocation
        let screenRect = CGRect(origin: screenPoint, size: CGSize(width: 1, height: 1))
        let windowRect = window.convertFromScreen(screenRect)
        let pointInView = onView.convert(windowRect.origin, from: nil)
        let rectInView = CGRect(origin: pointInView, size: CGSize(width: 1.0, height: 1.0))
        if CGRectContainsRect(onView.bounds, rectInView) {
            //            mouseDidEntered(with: currentEvent)
        } else {
            onView.mouseExited(with: currentEvent)
        }
    }
    
    private func removeAllHoverLayerAnimations(hoverLayer: CAShapeLayer) {
        hoverLayer.removeAllAnimations()
    }
}

// MARK: - CAAnimationDelegate
extension HoverHelper: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag { // 确保动画是自然完成的
            hoverLayer.removeFromSuperlayer()
        }
    }
}
