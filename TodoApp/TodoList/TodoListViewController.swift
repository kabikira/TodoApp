//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit
import Firebase

class TodoListViewController: UIViewController {
    
    var todoItems: [TodoItem] = []
    var isDone: Bool = false
    var listener: ListenerRegistration!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: TodoListCell.className, bundle: nil), forCellReuseIdentifier: TodoListCell.className)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.text = NSLocalizedString("Yes", comment: "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        getTodoDataForFirestore()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .updateTodoListview, object: nil)
        let yes     = NSLocalizedString("Yes", comment: "")
        let no      = NSLocalizedString("No", comment: "")
        let cancel  = NSLocalizedString("Cancel", comment: "")
        let confirm = NSLocalizedString("Confirm", comment: "")
        let search  = NSLocalizedString("Search", comment: "")

        print(yes)
        print(no)
        print(cancel)
        print(confirm)
        print(search)
    }

}
// MARK: - Actions
private extension TodoListViewController {
    @IBAction func tapAddButton(_ sender: Any) {
        // ①Todo作成画面に画面遷移
        Router.shared.showTodoAdd(from: self)
    }
    @IBAction func changeDoneControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isDone = false
            getTodoDataForFirestore()
        case 1:
            isDone = true
            getTodoDataForFirestore()
        default:
            isDone = false
            getTodoDataForFirestore()
        }
    }
    @IBAction func tapLogoutButton(_ sender: Any) {
        // ①ログイン済みかどうかを確認
        if Auth.auth().currentUser != nil {
            // ②ログアウトの処理

            do {
                // ③成功した場合はログイン画面へ遷移
                try Auth.auth().signOut()
                print("ログアウト完了")
                // ③成功した場合はログイン画面へ遷移
                Router.shared.showReStart()

            } catch let error as NSError {
                // ②が失敗した場合
                showErrorAlert(error: error, vc: self)
            }
        }
    }

}
// MARK: - Data Fetching
private extension TodoListViewController {
    @objc private func reloadData() {
        getTodoDataForFirestore()
        print("受け取ったよ")
    }
    func getTodoDataForFirestore()  {
        Task {
            do {
                let querySnapshot = try await FirebaseUserManager.fetchQuerySnapshot(isDone: isDone)
                let todoItems = createTodoItems(from: querySnapshot)
                self.todoItems = todoItems
                tableView.reloadData()
                print(todoItems)
            } catch {
                print("error")
            }
        }
    }
    func createTodoItems(from querySnapshot: QuerySnapshot) -> [TodoItem] {
        let todoItems = querySnapshot.documents.compactMap { doc -> TodoItem? in
            let data = doc.data()
            guard
                let title = data[FirestoreKeys.Todo.title.rawValue] as? String,
                let detail = data[FirestoreKeys.Todo.detail.rawValue] as? String,
                let isDone = data[FirestoreKeys.Todo.isDone.rawValue] as? Bool
            else { return nil }
            return TodoItem(
                id: doc.documentID,
                title: title,
                detail: detail,
                isDone: isDone
            )
        }
        return todoItems
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showTodoEdit(from: self, todoItem: todoItems[indexPath.row])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 未完了・完了済みの切り替えのスワイプ
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action :UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoItems[indexPath.row].id).updateData(
                    [
                        "isDone": !self.todoItems[indexPath.row].isDone,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]
                    ,completion: { error in
                        if let error = error {
                            self.showErrorAlert(error: error, vc: self)
                        } else {
                            print("TODO更新成功")
                            self.getTodoDataForFirestore()
                        }
                    }
                )
            }
        })
        editAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
        // controlの値によって表示するアイコンを切り替え
        switch isDone {
        case true:
            editAction.image = UIImage(systemName: "arrowshape.turn.up.left")
        default:
            editAction.image = UIImage(systemName: "checkmark")
        }
        //削除のスワイプ
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoItems[indexPath.row].id).delete() { error in
                    if let error = error  {
                        self.showErrorAlert(error: error, vc: self)
                    } else {
                        print("TODO削除成功")
                        self.getTodoDataForFirestore()
                    }
                }
            }
        })
        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        deleteAction.image = UIImage(systemName: "clear")
        // スワイプアクションを追加
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        // fullスワイプ時に挙動が起きないように制御
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }

}
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.className) as? TodoListCell else {
            fatalError()
        }

        let item = todoItems[indexPath.row]

        cell.configure(item: item)
        return cell
    }


}
