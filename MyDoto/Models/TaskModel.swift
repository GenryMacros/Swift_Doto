//
//  TaskModel.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 28/11/2021.
//

import Foundation

struct TaskModel {
    var task_names: Array<String> = Array<String>();
    var task_ids: Array<Int> = Array<Int>();
    
    mutating func clear() {
        task_names.removeAll()
        task_ids.removeAll()
    }
}
