//
//  CompletionViewController.swift
//  TodoListDelete
//
//  Created by 정동교 on 2023/08/31.
//

import UIKit

class CompletionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compleList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletionCell", for: indexPath) as! CompletionCell
        cell.compleCellLabel.text = compleList[indexPath.row].title
        return cell
    }
}
