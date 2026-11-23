//
//  UserModel.swift
//  Kuttaib
//
//  Created by mco on 19/10/26.
//

import Foundation

struct UserModel {
    var name: String
    var dailyVerseTarget: Int
    var dailyStudyTime: Int
    var reminderEnabled: Bool
}

struct UserDataModel: Decodable {
    let id: String?
    let name: String?
    let dailyVerseTarget: Double?
    let dailyStudyTime: Int?
}
