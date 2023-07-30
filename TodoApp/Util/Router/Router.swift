//
//  Router.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/21.
//

import UIKit


final class Router {
    static let shared: Router = .init()
    private init() {}


    private var window: UIWindow?
    func showRoot(window: UIWindow?) {
        if UserDefaults.standard.isLogined {
                guard let vc = UIStoryboard.init(name: "TodoList", bundle: nil).instantiateInitialViewController() else {
                    return
                }
                let nav = UINavigationController(rootViewController: vc)
                window?.rootViewController = nav
            } else {
                guard let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() else {
                    return
                }
                let nav = UINavigationController(rootViewController: vc)
                window?.rootViewController = nav
            }
        window?.makeKeyAndVisible()
        self.window = window
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
    func showTodoEdit(from: UIViewController, todoItem: TodoItem) {
        guard let todoEdit = UIStoryboard.init(name: "TodoEdit", bundle: nil).instantiateInitialViewController() as? TodoEditViewController else {
            return
        }
        todoEdit.configure(todoItems: todoItem)
        
        show(from: from, to: todoEdit)
    }

    func showReStart() {
        showRoot(window: window)
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
