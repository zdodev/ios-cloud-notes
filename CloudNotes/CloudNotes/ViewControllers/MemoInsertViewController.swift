import UIKit

class MemoInsertViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        doneButton.target = self
        doneButton.action = #selector(tappedDoneButton)
        
        setupTextView()
    }
    
    @objc private func tappedDoneButton(_ sender: UIBarButtonItem) {
        let newMemo = MemoModel(context: self.context)
        newMemo.title = extractTitle(memoTextView)
        newMemo.body = memoTextView.text
        newMemo.lastModified = Date.timeIntervalSinceReferenceDate
        context.saveContext()
        if let splitViewController = parent?.parent as? MainSplitVieWController {
            if let listViewController = splitViewController.viewControllers[0].children[0] as? MemoListTableViewController {
//                listViewController.fetchItems()
            }
        }
        
        if traitCollection.horizontalSizeClass == .compact {
            navigationController?.navigationController?.popViewController(animated: true)
        } else {
            
        }
    }
    
    private func extractTitle(_ textView: UITextView) -> String {
        let firstString = textView.text.split(separator: "\n")
        if firstString.isEmpty {
            return ""
        } else {
            let title = String(firstString[0])
            return title
        }
    }
    
    private func setupTextView() {
        memoTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        memoTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        memoTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        memoTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        memoTextView.becomeFirstResponder()
    }
}
