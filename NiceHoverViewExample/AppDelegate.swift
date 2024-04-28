//
//  AppDelegate.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/27.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    private let hoverView = CustomHoverView(frame: NSRect(x: 100, y: 100, width: 100, height: 100))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let contentView = window.contentView else { return }
        hoverView.wantsLayer = true
        hoverView.layer?.cornerRadius = 20
        hoverView.layer?.backgroundColor = NSColor.white.cgColor
        contentView.addSubview(hoverView)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

