//
//  TodoEditViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit
import Firebase

class TodoEditViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var isDoneLabel: UILabel!


    private var todoItems: TodoItem?
    func configure(todoItems: TodoItem) {
        self.todoItems = todoItems
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationItem.hidesBackButton = true
        // ②初期値をセット
        titleTextField.text = todoItems?.title
        detailTextView.text = todoItems?.detail

        switch todoItems?.isDone {
        case false:
            isDoneLabel.text = "未完了"
            doneButton.setTitle("完了済みにする", for: .normal)
        default:
            isDoneLabel.text = "完了"
            doneButton.setTitle("未完了にする", for: .normal)
        }
    }
    override func viewDidLayoutSubviews() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    @IBAction private func tapDoneButton(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            guard let todoItems = todoItems else { return }
            Firestore.firestore().collection("users/\(user.uid)/todos").document(todoItems.id).updateData(
                [
                    "isDone": !(todoItems.isDone),
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                ,completion: { error in
                    if let error = error {
                        self.showErrorAlert(error: error, title: "TODO更新失敗", vc: self)
                    } else {
                        print("TODO更新成功")
                        NotificationCenter.default.post(name: .updateTodoListview, object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                })
        }
    }

    @IBAction private func tapEditButton(_ sender: Any) {
        if let title = titleTextField.text,
           let detail = detailTextView.text {
            if let user = Auth.auth().currentUser {
                guard let todoItems = todoItems else { return }
                Firestore.firestore().collection("users/\(user.uid)/todos").document(todoItems.id).updateData(
                    [
                        "title": title,
                        "detail": detail,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]
                    ,completion: { error in
                        if let error = error {
                            self.showErrorAlert(error: error, title: "TODO更新失敗", vc: self)
                        } else {
                            print("TODO更新成功")
                            NotificationCenter.default.post(name: .updateTodoListview, object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
            }
        }
    }

    @IBAction private func tapDeleteButton(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            guard let todoItems = todoItems else { return }
            Firestore.firestore().collection("users/\(user.uid)/todos").document(todoItems.id).delete(){ error in
                if let error = error {
                    self.showErrorAlert(error: error, title: "TODO削除失敗", vc: self)
                } else {
                    print("TODO削除成功")
                    NotificationCenter.default.post(name: .updateTodoListview, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}
