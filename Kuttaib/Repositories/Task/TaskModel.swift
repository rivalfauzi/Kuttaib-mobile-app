//
//  TaskModel.swift
//  Kuttaib
//
//  Created by mco on 20/10/26.
//

import Foundation

struct TaskModel {
    var id: UUID?
    var status: TaskStatus?
    var surahNumber: Int?
    var startAyah: Int?
    var endAyah: Int?
    var completedEndAyah: Int?
    var type: TaskType?
    var taskDate: Date?
}
