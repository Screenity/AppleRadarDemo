//
//  AlertViewMaker.swift
//  ParentalControlDemo
//
//  Created by Salavat Khanov on 20.01.2022.
//

import SwiftUI

protocol AlertViewMaker {
    associatedtype ViewModelSubclass: ViewModel
    var model: ViewModelSubclass { get }
}

extension AlertViewMaker {
    func alert(forItem alertItem: ViewModel.AlertItem) -> Alert {
        let titleText = alertItem.title
        let messageText = alertItem.message ?? ""
        
        switch alertItem.id {
        case .error: return Alert(
            title: Text(titleText),
            message: Text(messageText)
        )
        case .confirmation: return Alert(
            title: Text(titleText),
            message: Text(messageText)
        )
        }
    }
}

