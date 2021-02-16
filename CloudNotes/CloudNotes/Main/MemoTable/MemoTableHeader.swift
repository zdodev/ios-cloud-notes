//
//  MemoTableHeader.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

class MemoTableHeader: UIView {
    // MARK: - UI Properties
    private lazy var memoTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메모"
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGroupedBackground
        setupMemoTitle()
        setupAddButton()
    }
    
    private func setupMemoTitle() {
        self.addSubview(memoTitleLable)
        memoTitleLable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        memoTitleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupAddButton() {
        self.addSubview(addButton)
        addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
