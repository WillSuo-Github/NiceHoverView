//
//  AppDelegate.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/27.
//

import Cocoa
import SnapKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    private let hoverView = CustomHoverView(frame: .zero)
    private let customTableViewController = CustomTableViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let contentView = window.contentView else { return }
        hoverView.wantsLayer = true
        hoverView.layer?.cornerRadius = 20
        hoverView.layer?.backgroundColor = NSColor.white.cgColor
        contentView.addSubview(hoverView)
        hoverView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        contentView.addSubview(customTableViewController.view)
        customTableViewController.view.snp.makeConstraints { make in
            make.left.bottom.width.equalToSuperview()
            make.top.equalTo(hoverView.snp.bottom)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

