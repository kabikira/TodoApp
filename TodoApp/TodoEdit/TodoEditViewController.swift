//
//  TodoEditViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit

class TodoEditViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var isDoneLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true

    }

    @IBAction private func tapDoneButton(_ sender: Any) {
    }

    @IBAction private func tapEditButton(_ sender: Any) {
    }

    @IBAction private func tapDeleteButton(_ sender: Any) {
    }

}
