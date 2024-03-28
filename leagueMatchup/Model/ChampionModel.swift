//
//  ChampionModel.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 01/02/24.
//

import Foundation

struct ChampionResponse: Codable, Hashable {
    var data: [String: ChampionModel]
}

struct ChampionModel: Codable, Hashable {
    var id: String
    var key: String
    var name: String
    var title: String
    var blurb: String
    var tags: [String]
    var imageURL: URL?
}
