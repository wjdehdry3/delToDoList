//
//  TodoViewController.swift
//  TodoListDelete
//
//  Created by 정동교 on 2023/08/31.
//

import UIKit

class TodoViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
 
    let saveData = UserDefaults.standard
    let vc = UIViewController()
    var selectedSection = 0
    var pf = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pf.delegate = self
        pf.dataSource = self
        findList()
        findcompleList()
        findSection()
    }
    
    

    @IBAction func todoCreatButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "디렉토리에서 할일을 관리하세요", message: "", preferredStyle: .alert)

        let createAction = UIAlertAction(title: "이 디렉토리에 할일 생성", style: .default) { action in
            self.sectionAlert()
        }
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        

        let addAction = UIAlertAction(title: "디렉토리 생성", style: .destructive) { action in

            let sectionAlert = UIAlertController(title: "디렉토리 명을 정해주세요", message: "", preferredStyle: .alert)

            sectionAlert.addTextField { alertTextField in
                alertTextField.placeholder = "디렉토리 명을 써주세요"
                textField = alertTextField
            }
            

            let sectionAddAction = UIAlertAction(title: "추가", style: .default) { action in
                if let sectionName = textField.text {
                    let appendList = [List]()
                    sections.append(sectionName)
                    list.append(appendList)
                    
                    self.setSection(sections)
                    self.setList(list)
                    self.pf.reloadAllComponents()
                    self.todoTableView.reloadData()
                }
            }
            let sectionCancelAction = UIAlertAction(title: "취소", style: .cancel)
            

            sectionAlert.addAction(sectionAddAction)
            sectionAlert.addAction(sectionCancelAction)
            self.present(sectionAlert, animated: true)
        }
        

        if(sections.count == 0){
            alert.title = "디렉토리를 만들어 할일을 관리하세요!"
        }
        if(sections.count != 0){
            alert.title = "디렉토리에서 할일을 관리하세요"
            vc.view = pf
            alert.setValue(vc, forKey: "contentViewController")
        }
        
        
        if(sections.count != 0){
            alert.addAction(createAction)
        }
        
        alert.addAction(addAction)
        alert.addAction(cancle)
        
        present(alert, animated: true)
    }
    
   
    
    

    func sectionAlert() {
        var textField = UITextField()
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")

        let mainAlert = UIAlertController(title: "List 작성", message: "", preferredStyle: .alert)
        

        let mainAddAction = UIAlertAction(title: "추가", style: .default) { action in
            if textField.text != "" {
                let newItem = List(title: textField.text!, done: false , date: dateData())
                list[self.selectedSection].append(newItem)

                self.setList(list)
                self.todoTableView.reloadData()
            }
        }
        func dateData () -> String{
            return String("\(datePicker.date)".prefix(10))
        }

        let mainCancelAction = UIAlertAction(title: "취소", style: .cancel)
        

        mainAlert.addTextField{ alertTextField in
            alertTextField.placeholder = "할일을 써주세요"
            textField = alertTextField
        }
        
        vc.view = datePicker
        mainAlert.setValue(vc, forKey: "contentViewController")
        mainAlert.addAction(mainAddAction)
        mainAlert.addAction(mainCancelAction)
        present(mainAlert, animated: true)
    }
    
    @IBAction func todoCellSwitchAction(_ sender: UISwitch) {
        if let cell = sender.superview?.superview as? TodoCell, let indexPath = todoTableView.indexPath(for: cell) {
            let listfind = list[indexPath.section][indexPath.row]
            let newItem = List(title: listfind.title, done: sender.isOn, date: listfind.date)
            
            if sender.isOn {
                compleList.append(newItem)
            } else {
                if let indexToRemove = compleList.firstIndex(where: { $0.title == newItem.title }) {
                    compleList.remove(at: indexToRemove)
                }
            }
                  setCompleList(compleList)
            setSwitch(sender: cell.todoCellSwitch, indexPath: indexPath, listfind: listfind.title)
            }
    }
}


extension TodoViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let listfind = list[indexPath.section][indexPath.row]

        if editingStyle == .delete {
            list[indexPath.section].remove(at: indexPath.row)
            
            if let deleteIndex = compleList.firstIndex(where: { $0.title == listfind.title }) {
                compleList.remove(at: deleteIndex)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            setList(list)
            setCompleList(compleList)
            setSection(sections)
            
            if list[indexPath.section].isEmpty {
                sections.remove(at: indexPath.section)
                list.remove(at: indexPath.section)
                
                setSection(sections)
                setList(list)
                
                pf.reloadAllComponents()
                todoTableView.reloadData()
                
                if selectedSection >= sections.count && selectedSection != 0 {
                    selectedSection = sections.count - 1
                }
            }
        }
        
    }
}


extension TodoViewController: UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < list.count {
            return list[section].count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else { return UITableViewCell() }
        cell.todoCellSwitch.isOn = list[indexPath.section][indexPath.row].done
        cell.todoCellLabel.text = list[indexPath.section][indexPath.row].title
        cell.todoCellSwitch.tag = indexPath.row
        cell.todoCellDateLabel.text = list[indexPath.section][indexPath.row].date

        selectedSection2 = indexPath.section
        
        findSwitch(cell.todoCellSwitch, indexPath: indexPath, item: cell.todoCellLabel.text!)
        cell.todoCellSwitch.addTarget(self, action: #selector(self.tSwitch(sender:)), for: .valueChanged)
        
        if list[indexPath.section][indexPath.row].done {
            cell.todoCellLabel.attributedText = cell.todoCellLabel.text?.strikeThrough()
        }
        
        return cell
    }
    @objc func tSwitch (sender : UISwitch)  {
        if(list[selectedSection2][sender.tag].done){
            list[selectedSection2][sender.tag].done = false
        }else{
            list[selectedSection2][sender.tag].done = true
        }
        todoTableView.reloadData()
    }
    
}



extension TodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = row
    }
}



extension TodoViewController {

    func setList(_ list: [[List]]){
        DispatchQueue.global().async {
            let propertyListEncoder = try? PropertyListEncoder().encode(list)
            self.saveData.set(propertyListEncoder, forKey: "ToDoList")

        }
    }
    
    func setCompleList(_ doneList: [List]){
        DispatchQueue.global().async {
            let propertyListEncoder = try? PropertyListEncoder().encode(doneList)
            self.saveData.set(propertyListEncoder, forKey: "DoneList")
        }
    }
    func findList() {
        if let data = saveData.data(forKey: "ToDoList") {
            if let decodedList = try? PropertyListDecoder().decode([[List]].self, from: data) {
                list = decodedList
            }
        }
    }
    
    func setSection(_ sections: [String]){
        DispatchQueue.global().async {
            let propertyListEncoder = try? PropertyListEncoder().encode(sections)
            self.saveData.set(propertyListEncoder, forKey: "Sections")
        }
    }
    
    func setSwitch(sender: UISwitch, indexPath: IndexPath, listfind: String){
            let switchKey = "SwitchState \(indexPath.section) \(indexPath.row) \(listfind)"
            saveData.set(sender.isOn, forKey: switchKey)
        }
    
    
    func findcompleList() {
        if let data = saveData.data(forKey: "CompleList") {
            if let decodedList = try? PropertyListDecoder().decode([List].self, from: data) {
                compleList = decodedList
            }
        }
    }
    
    func findSection() {
        if let data = saveData.data(forKey: "Sections") {
            if let decodedSections = try? PropertyListDecoder().decode([String].self, from: data) {
                sections = decodedSections
            }
        }
    }
    
    func findSwitch(_ switchControl: UISwitch, indexPath: IndexPath, item: String) {
           let switchKey = "SwitchState \(indexPath.section) \(indexPath.row) \(item)"
           let switchState = saveData.bool(forKey: switchKey)
           switchControl.isOn = switchState
       }
    
}



