//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: TodoListCell.className, bundle: nil), forCellReuseIdentifier: TodoListCell.className)
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapLogoutButton(_ sender: Any) {
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
    }

    @IBAction func changeDoneControl(_ sender: UISegmentedControl) {
    }



}
