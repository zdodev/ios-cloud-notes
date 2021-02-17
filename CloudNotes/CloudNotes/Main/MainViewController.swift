//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// TODO: textview content tracking URL, phone, date
class MainViewController: UIViewController {
    // MARK: - UI Properties
    private lazy var memoListTableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        return textView
    }()
    private var statusBarView: UIView?
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
        setupTable()
        setupTextView()
        setupKeyboard()
        memoDetailTextviewChange(to: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupStatusBar()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupLayout(with: previousTraitCollection)
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
            memoListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            memoListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            memoListTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
            memoDetailTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            memoDetailTextView.leadingAnchor.constraint(equalTo: memoListTableView.trailingAnchor),
            memoDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            memoDetailTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupStatusBar() {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarManager = window?.windowScene?.statusBarManager
            if statusBarView != nil {
                statusBarView?.frame = statusBarManager?.statusBarFrame ?? CGRect.zero
                return
            }
            statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBarView?.backgroundColor = .systemGroupedBackground
            guard let statusBarView = self.statusBarView else {
                return
            }
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = .systemGroupedBackground
        }
    }
    
    private func setupLayout(with previousTraitCollection: UITraitCollection?) {
        NSLayoutConstraint.activate(commonConstraints)
        if statusBarView?.frame == CGRect.zero {
            setupStatusBar()
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            memoDetailTextView.isHidden = true
            statusBarView?.isHidden = false
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            memoDetailTextView.isHidden = false
            statusBarView?.isHidden = true
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    private func setupTable() {
        memoListTableView.rowHeight = UITableView.automaticDimension
        memoListTableView.estimatedRowHeight = 70
        memoListTableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "memoCell")
    }
    
    private func setupTextView() {
        memoDetailTextView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        memoDetailTextView.addGestureRecognizer(tapGesture)
        setTextViewAllDataDetectorTypes()
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoDetailTextView.isEditable = true
        memoDetailTextView.dataDetectorTypes = []
        memoDetailTextView.becomeFirstResponder()
    }
    
    private func setTextViewAllDataDetectorTypes() {
        memoDetailTextView.isEditable = false
        memoDetailTextView.dataDetectorTypes = [.all]
    }
    
    private func setupKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton(_:)))
        keyboardToolbar.items = [doneButton]
        
        memoDetailTextView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func touchUpDoneButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK: - memoDetailTextView Method
    func memoDetailTextviewChange(to index: Int) {
        guard let items = sampleMemoData else {
            return
        }
        memoDetailTextView.text = items[index].body
    }
}

// MARK: - TextView Delegate
extension MainViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.setTextViewAllDataDetectorTypes()
    }
}
