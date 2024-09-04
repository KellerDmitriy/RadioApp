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
    
    enum CodingKeys: String, CodingKey {
      case id = "stationuuid"
      case name
      case url
      case favicon
      case tags
      case countryCode = "countrycode"
      case votes
    }
    
    init(id: String, name: String, url: String, favicon: String, tags: String, contryCode: String, votes: Int) {
        self.id = id
        self.name = name
        self.url = url
        self.favicon = favicon
        self.tags = tags
        self.countryCode = contryCode
        self.votes = votes
        
    }
    
    var representation: [String: Any] {
        var dict = [String: Any]()
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }

    init?(docSnap: DocumentSnapshot) {
        guard let data = docSnap.data() else { return nil }
        
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let favicon = data["favicon"] as? String,
              let url = data["url"] as? String,
              let tags = data["tags"] as? String,
              let countryCode = data["countryCode"] as? String,
              let votes = data["votes"] as? Int else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.favicon = favicon
        self.url = url
        self.tags = tags
        self.countryCode = countryCode
        self.votes = votes
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
            contryCode: "US",
            votes: 201303
        )
        return station
    }
}

struct Like: Codable {
    var idUUID = UUID()
    var likeSet: Set<String>
}




