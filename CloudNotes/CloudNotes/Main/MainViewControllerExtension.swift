//
//  MainViewControllerExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension MainViewController: UITableViewDelegate {
}
