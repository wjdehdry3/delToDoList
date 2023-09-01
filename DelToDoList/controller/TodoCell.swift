//
//  CustomCell.swift
//  TodoListDelete
//
//  Created by 정동교 on 2023/08/31.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoCellLabel: UILabel!
    @IBOutlet weak var todoCellSwitch: UISwitch!
    
    @IBOutlet weak var todoCellDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
