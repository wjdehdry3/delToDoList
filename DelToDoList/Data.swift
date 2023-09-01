//
//  Data.swift
//  TodoListDelete
//
//  Created by 정동교 on 2023/08/31.
//

import Foundation
import UIKit

struct List: Codable {
    var title : String
    var done : Bool
    var date : String
}

var Category = [List]()
var compleList = [List]()
var selectedSection2 = 0

struct ImageData: Codable {
    let url: String

}
var list = [Category]
var sections : Array<String> = []

struct methodData {
    let saveData = UserDefaults.standard

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



