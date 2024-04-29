//
//  HoverProtocol.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/28.
//

import AppKit

public protocol HoverProtocol {    
    func hoverColor() -> NSColor
    func hoverRect() -> NSRect
    func xRadius() -> CGFloat
    func yRadius() -> CGFloat
}
