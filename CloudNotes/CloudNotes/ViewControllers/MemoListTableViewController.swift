//
//  MemoListTableViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    weak var delegate: MemoListSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        fetchMemo()
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

    @objc func addMemo() {
        delegate?.memoCellSelect(nil)
        moveToMemoDetailViewController()
    }
    
    private func moveToMemoDetailViewController() {
        if let memoDetailViewController = delegate as? MemoDetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
            splitViewController?.showDetailViewController(memoDetailNavigationController, sender: nil)
        }
    }
    
    private func fetchMemo() {
        do {
            try MemoModel.shared.fetch()
            self.tableView.reloadData()
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupMemoCell(with: MemoModel.shared.list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.memoCellSelect(indexPath.row)
        self.moveToMemoDetailViewController()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, _) in
            self.deleteMemoObject(with: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteMemoObject(with index: Int) {
        do {
            try MemoModel.shared.delete(index: index)
            self.deleteMemo(indexRow: index)
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController: MemoDetailDelegate {
    func saveMemo(indexRow: Int) {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func deleteMemo(indexRow: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: indexRow, section: 0)], with: .automatic)
    }
    
    func selectUpdateMemo(indexRow: Int) {
        
    }
    
    func updateMemo(indexRow: Int) {
        self.tableView.reloadRows(at: [IndexPath(row: indexRow, section: 0)], with: .automatic)
    }
}

protocol MemoListSelectDelegate: class {
    func memoCellSelect(_ index: Int?)
}
