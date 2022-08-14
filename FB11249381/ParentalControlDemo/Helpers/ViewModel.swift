//
//  ViewModel.swift
//  ParentalControlDemo
//
//  Created by Salavat Khanov on 20.01.2022.
//

import SwiftUI

class ViewModel: NSObject {
    
    // MARK: - Presenting Alerts
    
    struct AlertItem: Identifiable {
        enum AlertType {
            case error, confirmation
        }
        
        var id: AlertType
        var title: String
        var message: String?
    }
    
    @Published var activeAlert: AlertItem? = nil
    
    // MARK: - Presenting Errors
    
    func showErrorIfNotNil(_ error: Error?) {
        guard let error = error else { return }
        let m = String(describing: error) != error.localizedDescription ? String(describing: error) : nil
        activeAlert = .init(id: .error, title: error.localizedDescription, message: m)
    }
    
    // MARK: - Presenting Confirmation Dialogs
    
    func showConfirmation(title: String, message: String?) {
        activeAlert = .init(id: .confirmation, title: title, message: message)
    }
    
}
