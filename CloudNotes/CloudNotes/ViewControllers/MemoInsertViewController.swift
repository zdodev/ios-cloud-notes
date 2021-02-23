import UIKit

class MemoInsertViewController: UIViewController {
    private let doneButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .done)
        return barButtonItem
    }()
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memoTextView)
        navigationItem.rightBarButtonItem = doneButton
        
        setupTextView()
    }
    
    private func setupTextView() {
        memoTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        memoTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        memoTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        memoTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        memoTextView.becomeFirstResponder()
    }
}
