//
//  DisplayOrderType.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 12.09.2024.
//

import Foundation

enum DisplayOrderType: CaseIterable {
    case alphabetical
    case favoriteFirst

    var name: String {
        switch self {
        case .alphabetical:
            return "Alphabetical"
        case .favoriteFirst:
            return "Favorite First"
        }
    }
}
