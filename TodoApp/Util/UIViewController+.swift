//
//  UIViewController+.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/23.
//

import UIKit
extension UIViewController {
    func showErrorAlert(error: Error, title: String, vc: UIViewController) {
        print(title + error.localizedDescription)
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true, completion: nil)
    }
}

