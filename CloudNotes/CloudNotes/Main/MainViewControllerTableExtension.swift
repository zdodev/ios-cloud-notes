//
//  MainViewControllerExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.sampleMemoData else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = self.sampleMemoData,
              let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.displayUI(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.memoListTableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            selectTableViewCellCompactMode(to: indexPath.row)
        } else {
            selectTableViewCellRegularMode(to: indexPath.row)
        }
    }
    
    private func selectTableViewCellCompactMode(to: Int) {
        guard let memoList = self.sampleMemoData else {
            return
        }
        let memoDetailViewController = MemoDetailViewController()
        memoDetailViewController.memo = memoList[to]
        self.navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    private func selectTableViewCellRegularMode(to: Int) {
        self.memoDetailTextViewChange(to: to)
    }
}
