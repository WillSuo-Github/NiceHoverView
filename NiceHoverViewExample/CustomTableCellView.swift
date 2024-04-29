//
//  CustomTableCellView.swift
//  NiceHoverViewExample
//
//  Created by will Suo on 2024/4/29.
//

import AppKit

final class CustomTableCellView: NSTableCellView {
    private lazy var titleLabel = NSTextField(labelWithString: "Title")
    
    var title: String? {
        didSet {
            titleLabel.stringValue = title ?? ""
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension CustomTableCellView {
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}
