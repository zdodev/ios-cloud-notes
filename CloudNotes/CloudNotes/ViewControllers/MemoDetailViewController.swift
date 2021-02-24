//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/18.
//

import UIKit

class MemoDetailViewController: UIViewController {
    // MARK: - UI property
    private lazy var memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    // MARK: - data property
    private var memo: MemoModel? {
        didSet {
            displayMemo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupTextView()
        setupKeyboard()
        displayMemo()
    }
    
    // MARK: - setup UI
    private func setupNavigationBar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func showActionSheet(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareSheet = UIAlertAction(title: "Share...", style: .default) { _ in
            print("click to share sheet")
        }
        let deleteSheet = UIAlertAction(title: "Delete...", style: .destructive) { _ in
            print("click to delete sheet")
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
        guard let memo = memo else {
            return
        }
        
        let content = NSMutableAttributedString(string: memo.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSAttributedString(string: "\n\n" + memo.body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        memoDetailTextView.attributedText = content
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
    func memoCellSelect(_ memo: MemoModel) {
        self.memo = memo
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
