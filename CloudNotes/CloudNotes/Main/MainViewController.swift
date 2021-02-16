//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    // MARK: - UI Properties
    private lazy var memoListTableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
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
    let memoListTableHeader = MemoTableHeader()
    
    // MARK: - data property
    var sampleMemoData: [Memo]? = nil
    
    // MARK: - UI Constraints
    private var commonConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try initMemoSampleData()
        } catch {
            self.showError(error, okHandler: nil)
        }
        setupUI()
        setupConstraints()
        traitCollectionDidChange(UIScreen.main.traitCollection)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarManager = window?.windowScene?.statusBarManager
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBarView.backgroundColor = .systemGroupedBackground
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = .systemGroupedBackground
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        NSLayoutConstraint.activate(commonConstraints)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            memoDetailTextView.isHidden = true
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
            memoDetailTextView.isHidden = false
        }
    }
    
    // MARK: - init data
    private func initMemoSampleData() throws {
        let jsonDecoder = JSONDecoder()
        guard let memoJsonData: NSDataAsset = NSDataAsset(name: "sample") else {
            throw MemoError.decodeData
        }
        self.sampleMemoData = try jsonDecoder.decode([Memo].self, from: memoJsonData.data)
    }

    // MARK: - setup Method
    private func setupUI() {
        self.view.addSubview(memoListTableView)
        self.view.addSubview(memoDetailTextView)
    }
    
    private func setupConstraints() {
        commonConstraints.append(contentsOf: [
            memoListTableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            memoListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            memoListTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            memoDetailTextView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memoDetailTextView.leadingAnchor.constraint(equalTo: memoListTableView.trailingAnchor),
            memoDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            memoDetailTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
