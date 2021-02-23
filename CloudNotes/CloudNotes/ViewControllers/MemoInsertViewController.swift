import UIKit

class MemoInsertViewController: UIViewController {
    let moreButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "ellipsis.circle")
        return barButtonItem
    }()
    
    let doneButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .done)
        return barButtonItem
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memoTextView)
        navigationItem.rightBarButtonItems = [doneButton, moreButton]
        
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
