//
//  Model.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import Foundation
import FirebaseFirestore

// MARK: - JSON Model
struct StationModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let url: String
    let favicon: String
    let tags: String
    let countryCode: String
    var votes: Int
    var isFavorite = false

    enum CodingKeys: String, CodingKey {
        case id = "stationuuid"
        case name
        case url
        case favicon
        case tags
        case countryCode = "countrycode"
        case votes
        case isFavorite
    }

    init(id: String, name: String, url: String, favicon: String, tags: String, countryCode: String, votes: Int, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.url = url
        self.favicon = favicon
        self.tags = tags
        self.countryCode = countryCode
        self.votes = votes
        self.isFavorite = isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.favicon = try container.decode(String.self, forKey: .favicon)
        self.tags = try container.decode(String.self, forKey: .tags)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.votes = try container.decode(Int.self, forKey: .votes)
        self.isFavorite = false
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.favicon, forKey: .favicon)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.countryCode, forKey: .countryCode)
        try container.encode(self.votes, forKey: .votes)
        try container.encode(self.isFavorite, forKey: .isFavorite)
    }
}

// MARK: - Preview data
extension StationModel {
    static func testStation() -> StationModel {
        let station = StationModel(
            id: "9617a958-0601-11e8-ae97-52543be04c81",
            name: "Radio Paradise (320k)",
            url: "http://stream-uk1.radioparadise.com/aac-320",
            favicon: "https://www.radioparadise.com/favicon-32x32.png",
            tags: "california,eclectic,free,internet,non-commercial,paradise,radio",
            countryCode: "US",
            votes: 201303,
            isFavorite: true
        )
        return station
    }
}


