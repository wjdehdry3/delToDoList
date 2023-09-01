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

var dailyList = [List]()
var compleList = [List]()

var list = [dailyList]

var sections : Array<String> = []

struct ImageData: Codable {
    let url: String

}
var selectedSection2 = 0


