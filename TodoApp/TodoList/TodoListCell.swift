//
//  TodoListCell.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/09.
//

import UIKit

final class TodoListCell: UITableViewCell {

    static var className: String { String(describing: TodoListCell.self)}

    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }




}
