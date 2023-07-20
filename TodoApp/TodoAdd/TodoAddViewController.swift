//
//  TodoAddViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/20.
//

import UIKit

class TodoAddViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true

    }
    

    @IBAction func tapAddButton(_ sender: Any) {
    }
}
