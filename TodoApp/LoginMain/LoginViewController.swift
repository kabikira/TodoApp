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
        guard let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text else {
            return
        }
        Task {
            do {
                let user = try await FirebaseUserManager.registerUserToAuthentication(email: email, password: password)
                print("ユーザー作成完了 uid:" + user.uid)
                try await FirebaseUserManager.createUserToFirestore(userId: user.uid, userName: name)
                print("ユーザー作成完了 name:" + name)
                UserDefaults.standard.isLogined = true
                Router.shared.showTodoList(from: self)
            } catch {
                self.showErrorAlert(error: error, title: "新規登録失敗 ", vc: self)
            }
        }
    }

    @IBAction private func tapLoginButton(_ sender: Any) {
        guard let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text else {
            return
        }

        Task {
            do {
                try await FirebaseUserManager.loginUserToAuthentication(email: email, password: password)
                print("ログイン完了 uid:" + Auth.auth().currentUser!.uid)
                UserDefaults.standard.isLogined = true
                Router.shared.showTodoList(from: self)

            } catch {
                self.showErrorAlert(error: error, title: "ログイン失敗", vc: self)
            }
        }
    }
}

