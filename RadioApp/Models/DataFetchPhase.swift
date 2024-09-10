//
//  DataFetchPhase.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 10.09.2024.
//

import Foundation

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
}
