//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/18.
//

import UIKit

// TODO: scroll keyboard
class MemoDetailViewController: UIViewController {
    // MARK: - UI property
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    // MARK: - data property
    var index: Int? {
        didSet {
            displayMemo()
        }
    }
    weak var delegate: MemoDetailDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextView()
        setupKeyboard()
        displayMemo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if let index = index {
//            updateMemo(with: index)
//        } else {
//        }
//    }
    
    // MARK: - Memo Data CRUD
    private func updateMemo(with index: Int) {
        guard let memoString = memoDetailTextView.text else {
            return self.showError(MemoError.updateMemo, okHandler: nil)
        }
        let divideMemo = divideMemoString(with: memoString)
        guard let title = divideMemo.title,
              title.isNotEmpty else {
            return self.deleteMemo()
        }
        
        if isNotChangeMemo(with: index, title: title, body: divideMemo.body) {
            return
        }
        do {
            try MemoModel.shared.update(index: index, title: title, body: divideMemo.body)
            self.delegate?.updateMemo(indexRow: index)
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
    
    private func divideMemoString(with memo: String) -> (title: String?, body: String?) {
        var divideMemo = memo.components(separatedBy: "\n")
        let title = divideMemo.first
        divideMemo.remove(at: divideMemo.startIndex)
        let body = divideMemo.reduce("", { (result, memoBody) -> String in
            return result + memoBody
        })
        return (title, body)
    }
    
    private func isNotChangeMemo(with index: Int, title: String, body: String?) -> Bool {
        guard let originalTitle = MemoModel.shared.list[index].title else {
            return false
        }
        let isNotChangeTitle = originalTitle == title
        let isNotChangeBody = MemoModel.shared.list[index].body == body
        return isNotChangeTitle && isNotChangeBody
    }
    
    private func deleteMemo() {
        guard let index = index else {
            return self.showError(MemoError.deleteMemo, okHandler: nil)
        }
        do {
            try MemoModel.shared.delete(index: index)
            self.memoDetailTextView.text = nil
            self.delegate?.deleteMemo(indexRow: index)
        } catch {
            self.showError(error, okHandler: nil)
        }
        self.navigationController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(memoDetailTextView)
        memoDetailTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        memoDetailTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        memoDetailTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        memoDetailTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func showActionSheet(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareSheet = UIAlertAction(title: "Share...", style: .default) { _ in
            self.showShareActivityView()
        }
        let deleteSheet = UIAlertAction(title: "Delete...", style: .destructive) { _ in
            self.showDeleteMemoAlert()
        }
        let cancelSheet = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareSheet)
        actionSheet.addAction(deleteSheet)
        actionSheet.addAction(cancelSheet)
        
        if traitCollection.userInterfaceIdiom == .phone {
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            actionSheet.popoverPresentationController?.barButtonItem = sender
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func showShareActivityView() {
        let objectToShare = memoDetailTextView.text
        let activityViewController = UIActivityViewController(activityItems: [objectToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteMemoAlert() {
        let alertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteMemo()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupTextView() {
        memoDetailTextView.delegate = self
        memoDetailTextView.setTextViewAllDataDetectorTypes()
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
        if let memoIndex = index,
           let title = MemoModel.shared.list[memoIndex].title,
           let body = MemoModel.shared.list[memoIndex].body {
            let content = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
            content.append(NSAttributedString(string: "\n\n" + body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
            memoDetailTextView.attributedText = content
        } else {
            memoDetailTextView.text = nil
        }
    }
}

// MARK: - TextView Delegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.resignFirstResponder()
    }
}

extension MemoDetailViewController: MemoListSelectDelegate {
    func memoCellSelect(_ index: Int?) {
        if let originIndex = self.index {
            updateMemo(with: originIndex)
        }
        self.index = index
    }
    
    func memoCellDelete(_ index: Int) {
        guard let originIndex = self.index,
              originIndex == index else {
            return
        }
        /*
         * 현재 textView에 표시된 메모를 삭제한 경우에는
         * 메모 리스트의 첫 메모를 띄어주거나
         * 리스트가 비어 있다면 새로운 메모를 추가해줘야 함
         */
        if MemoModel.shared.list.isEmpty {
            self.delegate?.insertNewMemo()
        } else {
            self.index = MemoModel.shared.list.startIndex
        }
    }
}

// TODO: refactor
extension UITextView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches")
        let touch = touches.first!
        var location = touch.location(in: self)
        
        let layoutManager = self.layoutManager
        location.x -= self.textContainerInset.left
        location.y -= self.textContainerInset.top
        
        let glyphIndex: Int = self.layoutManager.glyphIndex(for: location, in: self.textContainer, fractionOfDistanceThroughGlyph: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: self.textContainer)
        
        if glyphRect.contains(location) {
            let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
            let attributeName = NSAttributedString.Key.link
            let attributeValue = self.textStorage.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let url = attributeValue as? URL {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("There is a problem in your link.")
                }
            } else {
                // place the cursor to tap position
                placeCursor(self, location)
                        
                // back to normal state
                self.changeTextViewToNormalState()
            }
        } else {
            changeTextViewToNormalState()
        }
    }
    
    fileprivate func placeCursor(_ myTextView: UITextView, _ location: CGPoint) {
        // place the cursor on tap position
        if let tapPosition = myTextView.closestPosition(to: location) {
            let uiTextRange = myTextView.textRange(from: tapPosition, to: tapPosition)
                
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = myTextView.offset(from: myTextView.beginningOfDocument, to: tapPosition)
                let length = myTextView.offset(from: start, to: end)
                myTextView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    fileprivate func changeTextViewToNormalState() {
        self.isEditable = true
        self.dataDetectorTypes = []
        self.becomeFirstResponder()
    }
}

protocol MemoDetailDelegate: class {
    func insertNewMemo()
    func deleteMemo(indexRow: Int)
    func updateMemo(indexRow: Int)
}
