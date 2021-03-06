//
//  Story.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 04/06/21.
//

import Foundation

class Story : Codable {
    var id: Int
    var by: String
    var descendants: Int?
    var score: Int
    var time: Int
    var title: String
    var url: String?
    var kids: [Int]?
}
