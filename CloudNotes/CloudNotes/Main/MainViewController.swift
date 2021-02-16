//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    // MARK: - UI Properties
    private lazy var memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - UI Constraints
    private var commonConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        NSLayoutConstraint.activate(commonConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            redView.isHidden = true
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
            redView.isHidden = false
        }
    }
    
    // MARK: - UI Constraints
    private var commonConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    private func setupUI() {
        self.view.addSubview(memoListTableView)
        self.view.addSubview(memoDetailTextView)
    }
    
    private func setupConstraints() {
        commonConstraints.append(contentsOf: [
            blueView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blueView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blueView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            blueView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            blueView.widthAnchor.constraint(equalToConstant: 200),
            redView.topAnchor.constraint(equalTo: self.view.topAnchor),
            redView.leadingAnchor.constraint(equalTo: blueView.trailingAnchor),
            redView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            redView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

