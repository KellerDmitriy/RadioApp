//
//  Model.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import Foundation
import FirebaseFirestore

// MARK: - JSON Model
// A model representing a radio station, conforming to Identifiable, Codable, and Hashable protocols
struct StationModel: Identifiable, Codable, Hashable, Equatable {
    let id: String           // Unique identifier for the station
    let name: String         // Name of the station
    let url: String          // URL of the station's stream
    let favicon: String      // URL to the station's favicon
    let tags: String         // Comma-separated tags describing the station
    let countryCode: String  // Country code of the station
    var votes: Int           // Number of votes the station has received
    var isFavorite: Bool     // Indicates if the station is marked as a favorite
    
//    static func == (lhs: StationModel, rhs: StationModel) -> Bool {
//        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.isFavorite == rhs.isFavorite
//    }
    
    // MARK: - Coding Keys
    // Maps the JSON keys to the properties of the struct
    enum CodingKeys: String, CodingKey {
        case id = "stationuuid"          // Maps "stationuuid" JSON key to the "id" property
        case name
        case url
        case favicon
        case tags
        case countryCode = "countrycode" // Maps "countrycode" JSON key to the "countryCode" property
        case votes
        case isFavorite
    }
    
    // MARK: - Initializers
    // Custom initializer to create a StationModel instance
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
    
    // Custom initializer to decode the StationModel from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.favicon = try container.decode(String.self, forKey: .favicon)
        self.tags = try container.decode(String.self, forKey: .tags)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.votes = try container.decode(Int.self, forKey: .votes)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    // Method to encode the StationModel to JSON
    func encode(to encoder: Encoder) throws {
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

// MARK: - Preview Data
// Extension to provide test data for previews or testing purposes
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
