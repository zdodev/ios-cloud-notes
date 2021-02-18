//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    // MARK: - UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private lazy var memoListTableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = statusBarColor
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
    private let statusBarColor = UIColor.systemGroupedBackground
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
        setupTable()
        setupTextView()
        setupKeyboard()
        setupConstraints()
        traitCollectionDidChange(UIScreen.main.traitCollection)
        memoDetailTextViewChange(to: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setupStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = statusBarColor
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - handle traitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupLayout()
    }
    
    private func setupLayout() {
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
        self.view.addSubview(containerView)
        containerView.addSubview(memoListTableView)
        containerView.addSubview(memoDetailTextView)
        self.navigationItem.title = "메모"
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
        memoDetailTextView.setTextViewAllDataDetectorTypes()
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoDetailTextView.isEditable = true
        memoDetailTextView.dataDetectorTypes = []
        memoDetailTextView.becomeFirstResponder()
    }
    
    private func setupKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil , action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(touchUpDoneButton(_:)))
        keyboardToolbar.items = [space, doneButton]
        
        memoDetailTextView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func touchUpDoneButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setupConstraints() {
        commonConstraints.append(contentsOf: [
            containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            memoListTableView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
        
        compactConstraints.append(contentsOf: [
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            memoListTableView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            memoListTableView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.4),
            memoDetailTextView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            memoDetailTextView.leadingAnchor.constraint(equalTo: memoListTableView.trailingAnchor),
            memoDetailTextView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
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
            statusBarView?.backgroundColor = statusBarColor
            guard let statusBarView = self.statusBarView else {
                return
            }
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = statusBarColor
        }
    }
}

// MARK: - TextView Delegate
extension MainViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.setTextViewAllDataDetectorTypes()
    }
    
    func memoDetailTextViewChange(to index: Int) {
        guard let items = sampleMemoData else {
            return
        }
        memoDetailTextView.text = items[index].body
    }
}
