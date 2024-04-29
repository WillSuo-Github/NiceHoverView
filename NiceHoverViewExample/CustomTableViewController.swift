//
//  CustomTableViewController.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/29.
//

import AppKit

final class CustomTableViewController: NSViewController {
    private lazy var tableView: NSTableView = {
        let result = NSTableView(frame: .zero)
        result.style = .plain
        result.focusRingType = .none
        result.selectionHighlightStyle = .regular
        result.backgroundColor = .clear
        result.usesAutomaticRowHeights = true
        result.delegate = self
        result.dataSource = self
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Column"))
        result.addTableColumn(column)
        result.focusRingType = .none
        result.headerView = nil
        return result
    }()
    
    private lazy var scrollView: NSScrollView = {
        let result = NSScrollView(frame: .zero)
        result.hasVerticalScroller = true
        result.hasHorizontalScroller = false
        result.autohidesScrollers = true
        result.drawsBackground = false
        result.automaticallyAdjustsContentInsets = false
        result.horizontalScrollElasticity = .none
        result.documentView = tableView
        return result
    }()
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - UI
extension CustomTableViewController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - NSTableViewDataSource & NSTableViewDelegate
extension CustomTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Cell")
        var cell = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? CustomTableCellView
        if cell == nil {
            cell = CustomTableCellView()
            cell?.identifier = cellIdentifier
        }
        cell?.title = "Row \(row)"
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Row")
        var rowView = tableView.makeView(withIdentifier: rowIdentifier, owner: self) as? NiceHoverTableRowView
        if rowView == nil {
            rowView = NiceHoverTableRowView()
            rowView?.identifier = rowIdentifier
        }
        return rowView
    }
}
