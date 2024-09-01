//
//  Model.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import Foundation

// MARK: - JSON Model
struct StationModel: Codable, Hashable {
    let stationuuid: String
    let name: String
    let url: String
    let favicon: String
    let tags: String
    let countrycode: String
    var votes: Int32
}

// MARK: - Preview data
extension StationModel {
    static func testStation() -> StationModel {
        let station = StationModel(
            stationuuid: "9617a958-0601-11e8-ae97-52543be04c81",
            name: "Radio Paradise (320k)",
            // url for streaming data
            url: "http://stream-uk1.radioparadise.com/aac-320",
            favicon: "https://www.radioparadise.com/favicon-32x32.png",
            tags: "california,eclectic,free,internet,non-commercial,paradise,radio",
            countrycode: "US",
            votes: 201303
        )
        return station
    }
}

struct Like: Codable {
    var idUUID = UUID()
    var likeSet: Set<String>
}




