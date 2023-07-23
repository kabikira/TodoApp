//
//  Router.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/21.
//

import UIKit
import Firebase

final class Router {
    static let shared: Router =  .init()
    private init() {}
    // Firebaseをインポートしないほうがいいかもしれない?? ログイン時UserDafaultsでに値をいれて判断したほうがよい､ログアウト時にその値を削除する
    let user = Auth.auth().currentUser

    private var window: UIWindow?
    func showRoot(windon: UIWindow?) {
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user != nil {
                guard let vc = UIStoryboard.init(name: "TodoList", bundle: nil).instantiateInitialViewController() else {
                    return
                }
                let nav = UINavigationController(rootViewController: vc)
                windon?.rootViewController = nav
            } else {
                guard let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() else {
                    return
                }
                let nav = UINavigationController(rootViewController: vc)
                windon?.rootViewController = nav
            }
        }
        windon?.makeKeyAndVisible()
        self.window = windon
    }

    func showTodoList(from: UIViewController) {
        guard let todoList = UIStoryboard.init(name: "TodoList", bundle: nil).instantiateInitialViewController() else {
            return
        }
        show(from: from, to: todoList)
    }

    func showTodoAdd(from: UIViewController) {
        guard let todoadd = UIStoryboard.init(name: "TodoAdd", bundle: nil).instantiateInitialViewController() else {
            return
        }
        showPresent(from: from, to: todoadd)
    }
    func showTodoEdit(from: UIViewController, todoId: String, title: String, detail: String, todoIsDone: Bool) {
        guard let todoEdit = UIStoryboard.init(name: "TodoEdit", bundle: nil).instantiateInitialViewController() as? TodoEditViewController else {
            return
        }
        // TODO 本来はモデル作って渡す
        todoEdit.todoId = todoId
        todoEdit.todoTitle = title
        todoEdit.todoDetail = detail
        todoEdit.todoIsDone = todoIsDone
        
        show(from: from, to: todoEdit)
    }

    func showReStart() {
        showRoot(windon: window)
    }
    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil) {
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
    private func showPresent(from: UIViewController,to: UIViewController) {
        from.present(to , animated: true)
    }
}
