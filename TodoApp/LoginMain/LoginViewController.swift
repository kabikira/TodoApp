//
//  ViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet private weak var registerEmailTextField: UITextField!
    @IBOutlet private weak var registerPasswordTextField: UITextField!
    @IBOutlet private weak var registerNameTextField: UITextField!
    @IBOutlet private weak var loginEmailTextField: UITextField!
    @IBOutlet private weak var loginPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func tapRegisterButton(_ sender: Any) {
        if let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text {
            // ①FirebaseAuthにemailとpasswordでアカウントを作成する
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ユーザー作成完了 uid:" + user.uid)
                    // ②FirestoreのUsersコレクションにdocumentID = ログインしたuidでデータを作成する
                    Firestore.firestore().collection("users").document(user.uid).setData( ["name": name], completion: { error in
                        if let error = error {
                            // ②が失敗した場合
                            self.showErrorAlert(error: error, title: "Firestore 新規登録失敗", vc: self)
                        } else {
                            print("ユーザー作成完了 name:" + name)
                            // ③成功した場合はTodo一覧画面に画面遷移を行う
//                            let storyboard: UIStoryboard = self.storyboard!
//                            let next = storyboard.instantiateViewController(withIdentifier: "TodoListViewController")
                            Router.shared.showTodoList(from: self)
                        }

                    })
                } else if let error = error {
                    self.showErrorAlert(error: error, title: "Firebase Auth 新規登録失敗 ", vc: self)
                }
            })

        }
    }

    @IBAction private func tapLoginButton(_ sender: Any) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text {
            // ①FirebaseAuthにemailとpasswordでログインを行う
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ログイン完了 uid:" + user.uid)
                    // ②成功した場合はTodo一覧画面に画面遷移を行う
                    Router.shared.showTodoList(from: self)
                } else if let error = error {
                    // ①が失敗した場合
                    self.showErrorAlert(error: error, title: "ログイン失敗", vc: self)
                }
            })
        }
    }
}

