//
//  ProfileFlowError.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 22.08.2024.
//

import Foundation

enum ProfileFlowError: LocalizedError {
    // MARK: - Cases
    case logout
    case unknown(Error)
    
    // MARK: - Computed Properties
    /// Текущий язык, используемый в приложении
    var language: Language {
        LocalizationService.shared.language
    }
    
    /// Описание причины ошибки
    var failureReason: String? {
        switch self {
        case .logout:
            return Resources.Text.logOut.localized(language)
        case .unknown:
            return "Unknown"
        }
    }
    
    /// Описание ошибки для пользователя
    var errorDescription: String? {
        switch self {
        case .logout:
            return Resources.Text.areYouWantLogOut.localized(language)
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    /// Предложение по восстановлению после ошибки
    var recoverySuggestion: String? {
        return "recovery"
    }
    
    /// Якорь справки, предоставляющий дополнительную информацию
    var helpAnchor: String? {
        return "help anchor"
    }
    
    // MARK: - Static Methods
    
    /// Функция для маппинга ошибки в `ProfileFlowError`
    /// - Parameter error: Ошибка для маппинга
    /// - Returns: Маппированная ошибка `ProfileFlowError`
    static func map(_ error: Error) -> ProfileFlowError {
        return error as? ProfileFlowError ?? .unknown(error)
    }
}
