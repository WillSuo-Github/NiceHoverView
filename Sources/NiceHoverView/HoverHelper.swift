//
//  HoverHelper.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/28.
//

import AppKit

open class HoverHelper: NSObject {
    open private(set) var isMouseIn: Bool = false
    
    var hoverLayer: CAShapeLayer
    
    var trackingArea: NSTrackingArea?
    
    init(hoverLayer: CAShapeLayer) {
        self.hoverLayer = hoverLayer
        super.init()
    }
    
    func showHoverLayer(with event: NSEvent, onView: NSView, useAnimation: Bool) {
        guard isMouseIn == false else { return }
        isMouseIn = true
        
        if useAnimation {
            showHoverLayerWithAnimation(with: event, onView: onView)
        } else {
            showHoverLayerWithoutAnimation(onView: onView)
        }
    }
    
    private func showHoverLayerWithAnimation(with event: NSEvent, onView: NSView) {
        let location = event.locationInWindow
        let entryPoint = onView.convert(location, from: nil)
        
        if hoverLayer.superlayer == nil {
            onView.wantsLayer = true
            onView.layer?.addSublayer(hoverLayer)
        }
        
        removeAllHoverLayerAnimations(hoverLayer: hoverLayer)
        
        let centerPoint = CGPoint(x: onView.bounds.midX, y: onView.bounds.midY)
        let rawDeltaXRate = (centerPoint.x - entryPoint.x) / (onView.bounds.width / 2)
        let rawDeltaYRate = (centerPoint.y - entryPoint.y) / (onView.bounds.height / 2)
        
        let deltaX = 10 * rawDeltaXRate
        let deltaY = 10 * rawDeltaYRate
        
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
    
    private func showHoverLayerWithoutAnimation(onView: NSView) {
        if hoverLayer.superlayer == nil {
            onView.wantsLayer = true
            onView.layer?.addSublayer(hoverLayer)
        }
    }
    
    func hideHoverLayer(with event: NSEvent, onView: NSView, useAnimation: Bool) {
        guard isMouseIn else { return }
        isMouseIn = false
        
        if useAnimation {
            hideHoverLayerWithAnimation(with: event, onView: onView)
        } else {
            hideHoverLayerWithoutAnimation(onView: onView)
        }
    }
    
    private func hideHoverLayerWithAnimation(with event: NSEvent, onView: NSView) {
        let location = event.locationInWindow
        let exitPoint = onView.convert(location, from: nil)
        
        if hoverLayer.superlayer != nil {
            removeAllHoverLayerAnimations(hoverLayer: hoverLayer)
            
            let centerPoint = CGPoint(x: onView.bounds.midX, y: onView.bounds.midY)
            let rawDeltaXRate = (exitPoint.x - centerPoint.x) / (onView.bounds.width / 2)
            let rawDeltaYRate = (exitPoint.y - centerPoint.y) / (onView.bounds.height / 2)
            
            let deltaX = 10 * rawDeltaXRate
            let deltaY = 10 * rawDeltaYRate
            
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
    
    private func hideHoverLayerWithoutAnimation(onView: NSView) {
        hoverLayer.removeFromSuperlayer()
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
