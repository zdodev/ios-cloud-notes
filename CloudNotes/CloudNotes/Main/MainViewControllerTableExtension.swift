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
}
