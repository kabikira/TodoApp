//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/08.
//

import UIKit
import Firebase

class TodoListViewController: UIViewController {

    // Firestoreから取得するTodoのid,title,detail,isDoneを入れる配列を用意
    var todoIdArray: [String] = []
    var todoTitleArray: [String] = []
    var todoDetailArray: [String] = []
    var todoIsDoneArray: [Bool] = []
    // 画面下部の未完了、完了済みを判定するフラグ(falseは未完了)
    var isDone: Bool = false

    var listener: ListenerRegistration!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: TodoListCell.className, bundle: nil), forCellReuseIdentifier: TodoListCell.className)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // ①ログイン済みかどうか確認
//        if let user = Auth.auth().currentUser {
//            // ②ログインしているユーザー名の取得
//            Firestore.firestore().collection("users").document("FBx26V3tADWZvdRTA32Je5aWRLc2").getDocument(completion: {(snapshot,error) in
//                if let snap = snapshot {
//                    if let data = snap.data() {
//                        self.userNameLabel.text = data["name"] as? String
//                    }
//                } else if let error = error {
//                    print("ユーザー名取得失敗: " + error.localizedDescription)
//                }
//            })
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        if let userId = Auth.auth().currentUser?.uid {
            if listener == nil {
                listener = Firestore.firestore().collection("users/\(userId)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").addSnapshotListener({ (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        var idArray: [String] = []
                        var titleArray: [String] = []
                        var deetailArray: [String] = []
                        var isDoneArray: [Bool] = []
                        for doc in querySnapshot.documents {
                            let data = doc.data()
                            idArray.append(doc.documentID)
                            titleArray.append(data["title"] as! String)
                            deetailArray.append(data["detail"] as! String)
                            isDoneArray.append(data["isDone"] as! Bool)
                        }
                        self.todoIdArray = idArray
                        self.todoTitleArray = titleArray
                        self.todoDetailArray = deetailArray
                        self.todoIsDoneArray = isDoneArray
                        self.tableView.reloadData()

                    } else if let error = error {
                        print("TODO取得失敗: " + error.localizedDescription)
                    }
                })
            } else {
                print("!!!!!!!!!!!!")
            }
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
                print("ログアウト失敗: " + error.localizedDescription)
                // ②が失敗した場合
                let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(dialog, animated: true, completion: nil)
            }
        }
    }
    
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

    func getTodoDataForFirestore() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").getDocuments(completion: { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var isDoneArray:[Bool] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        isDoneArray.append(data["isDone"] as! Bool)
                    }
                    self.todoIdArray = idArray
                    self.todoTitleArray = titleArray
                    self.todoDetailArray = detailArray
                    self.todoIsDoneArray = isDoneArray
                    print(self.todoTitleArray)

                    self.tableView.reloadData()


                } else if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                }
            })
        }
    }

}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showTodoEdit(from: self, todoId: todoIdArray[indexPath.row], title: todoTitleArray[indexPath.row], detail: todoDetailArray[indexPath.row], todoIsDone: todoIsDoneArray[indexPath.row])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 未完了・完了済みの切り替えのスワイプ
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action :UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoIdArray[indexPath.row]).updateData(
                    [
                        "isDone": !self.todoIsDoneArray[indexPath.row],
                        "updatedAt": FieldValue.serverTimestamp()
                    ]
                    ,completion: { error in
                        if let error = error {
                            print("TODO更新失敗: " + error.localizedDescription)
                            let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(dialog, animated: true, completion: nil)
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
                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoIdArray[indexPath.row]).delete() { error in
                    if let error = error  {
                        print("TODO削除失敗: " + error.localizedDescription)
                        let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(dialog, animated: true, completion: nil)
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
        return todoTitleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.className) as? TodoListCell else {
            fatalError()
        }
        cell.titleLabel.text = todoTitleArray[indexPath.row]
        return cell
    }


}
