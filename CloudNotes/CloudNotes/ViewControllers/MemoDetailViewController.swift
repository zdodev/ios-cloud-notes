//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/18.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - UI property
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    private let moreButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "ellipsis.circle")
        return barButtonItem
    }()
    
    private let backButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "chevron.backward.circle")
        return barButtonItem
    }()
    
    // MARK: - data property
    private var memo: MemoModel? {
        didSet {
            displayMemo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = moreButton
        navigationItem.leftBarButtonItem = backButton
        
        moreButton.target = self
        moreButton.action = #selector(tappedMoreButton)
        backButton.target = self
        backButton.action = #selector(tappedBackButton)
        
        setupUI()
        setupTextView()
        setupKeyboard()
        displayMemo()
    }
    
    @objc private func tappedBackButton(_ sender: UIBarButtonItem) {
        if let memoIndex = memo?.index {
            let memoToUpdate = Memo.shared.list[Int(memoIndex)]
            memoToUpdate.body = memoDetailTextView.text
            context.saveContext()
        }
        navigationController?.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedMoreButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { alertAction in
                // 삭제
                if let memoIndex = self.memo?.index {
                    let memoToRemove = Memo.shared.list[Int(memoIndex)]
                    self.context.delete(memoToRemove)
                    self.context.saveContext()
                    self.navigationController?.navigationController?.popViewController(animated: true)
                    if let splitViewController = self.parent?.parent as? MainSplitVieWController {
                        if let listViewController = splitViewController.viewControllers[0].children[0] as? MemoListTableViewController {
//                            listViewController.fetchItems()
                        }
                    }
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        setupNavigationBar()
//    }
    
//    private func setupNavigationBar() {
//        if traitCollection.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
//            navigationController?.navigationBar.isHidden = false
//        } else {
//            navigationController?.navigationBar.isHidden = false
//        }
//    }
    
    // MARK: - setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(memoDetailTextView)
        memoDetailTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        memoDetailTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        memoDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        memoDetailTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
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
    
    private func displayMemo() {
        guard let memo = memo else {
            return
        }
        self.navigationItem.title = memo.title
        memoDetailTextView.text = memo.body
    }
}

// MARK: - TextView Delegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.setTextViewAllDataDetectorTypes()
    }
}

extension MemoDetailViewController: MemoListSelectDelegate {
    func memoCellSelect(_ memo: MemoModel) {
        self.memo = memo
    }
}
