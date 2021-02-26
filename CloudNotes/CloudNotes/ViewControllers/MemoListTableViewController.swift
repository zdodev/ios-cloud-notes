//
//  MemoListTableViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    weak var delegate: MemoListSelectDelegate?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
//        do {
//            try Memo.shared.decodeMemoData()
//            self.delegate?.memoCellSelect(Memo.shared.list[0])
//        } catch {
            // TODO: add Handling error
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
//        print("true")
    }
    
    private func fetchItems() {
        do {
            Memo.shared.list = try context.fetch(MemoModel.fetchRequest())
            tableView.reloadData()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    }
    
    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "memoCell")
    }
    
    // TODO: add method logic
    @objc func addMemo() {
        let memoInsertView = MemoInsertViewController()
        navigationController?.pushViewController(memoInsertView, animated: true)
    }
}

extension MemoListTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memo.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupMemoCell(with: Memo.shared.list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.memoCellSelect(Memo.shared.list[indexPath.row])
        if let memoDetailViewController = delegate as? MemoDetailViewController {
            Memo.shared.list[indexPath.row].setupIndex(Int64(indexPath.row))
            splitViewController?.showDetailViewController(UINavigationController(rootViewController: memoDetailViewController), sender: nil)
        }
    }
}

protocol MemoListSelectDelegate: class {
    func memoCellSelect(_ memo: MemoModel)
}
