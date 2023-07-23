//
//  TodoAddViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/20.
//

import UIKit
import Firebase

class TodoAddViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true


    }
    override func viewDidLayoutSubviews() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    

    @IBAction func tapAddButton(_ sender: Any) {
        if let title = titleTextField.text,
           let detail = detailTextView.text {
            // ②ログイン済みか確認
            if let userId = Auth.auth().currentUser?.uid {
                // ③FirestoreにTodoデータを作成する
                let createdTime = FieldValue.serverTimestamp()
                Firestore.firestore().collection("users/\(userId)/todos").document().setData(
                    [
                        "title": title,
                        "detail": detail,
                        "isDone": false,
                        "createdAt": createdTime,
                        "updatedAt": createdTime
                    ],merge: true // ←階層にデータを作成する場合はこちらをtrueにする
                    ,completion: { error in
                        if let error = error {
                            // ③が失敗した場合
                            self.showErrorAlert(error: error, title: "TODO作成失敗", vc: self)
                        } else {
                            print("TODO作成成功")
                            // ④Todo一覧画面に戻る
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
            }
        }
    }
}
