//
//  MainViewModel.swift
//  ParentalControlDemo
//
//  Created by Salavat Khanov on 20.01.2022.
//

import SwiftUI
import Combine

final class MainViewModel: ViewModel, ObservableObject {
    
    @ObservedObject var authorizationStatusManager = ParentalAuthorizationManager()
    
    override init() {
        super.init()
        subscribeForChangesObservation()
    }
    
    deinit {
        unsubscribeFromChangesObservation()
    }
    
    // MARK: - Actions
    
    func authorizeParentalControlButtonDidTap() {
        authorizationStatusManager.requestAuthorization { [weak self] result in
            if case let .failure(error) = result {
                self?.showErrorIfNotNil(error)
            }
        }
    }
    
    func revokeParentalControlAuthorizationButtonDidTap() {
        authorizationStatusManager.revokeAuthorization { [weak self] result in
            if case let .failure(error) = result {
                self?.showErrorIfNotNil(error)
            }
        }
    }
    
    // MARK: - KVO & Notifications
    
    private var cancellables: [AnyCancellable] = []
    
    private func forceUpdatingView() {
        DispatchQueue.main.async { [weak self] in
            withAnimation {
                self?.objectWillChange.send()
            }
        }
    }
    
    func subscribeForChangesObservation() {
        authorizationStatusManager.objectWillChange.sink { [weak self] _ in
            self?.forceUpdatingView()
        }.store(in: &cancellables)
    }
    
    func unsubscribeFromChangesObservation() {}
}
