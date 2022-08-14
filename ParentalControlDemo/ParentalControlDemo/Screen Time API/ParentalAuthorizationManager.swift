//
//  ParentalAuthorizationManager.swift
//  ParentalKit
//
//  Created by Salavat Khanov on 7/10/21.
//

import SwiftUI
import Combine
import FamilyControls

final class ParentalAuthorizationManager: ObservableObject {
    
    @Published private(set) var actualStatus: AuthorizationStatus? = nil {
        didSet {
            if actualStatus != .notDetermined && cachedStatus != actualStatus {
                cachedStatus = actualStatus
            }
        }
    }
    
    private var cachedStatus: AuthorizationStatus? {
        get { Defaults.standard.cachedParentalAuthorizationStatus }
        set { Defaults.standard.cachedParentalAuthorizationStatus = newValue }
    }
    
    private var center: AuthorizationCenter { .shared }
    
    init() {
        subscribeForChangesObservation()
        actualStatus = cachedStatus
    }
    
    deinit {
        unsubscribeFromChangesObservation()
    }
    
    func requestAuthorization(completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.center.requestAuthorization { result in
                switch result {
                case .success():
                    print("Request Authorization: success")
                    
                case .failure(let error):
                    print("Request Authorization: \(error.localizedDescription)")
                    
                    if let error = error as? FamilyControlsError {
                        print("Failure reason: \(String(describing: error.failureReason))")
                        print("Recovery suggestion: \(String(describing: error.recoverySuggestion))")
                        print("Help achor \(String(describing: error.helpAnchor))")
                    }
                }
                
                DispatchQueue.main.async {
                    completionHandler?(result)
                }
            }
        }
    }
    
    func revokeAuthorization(completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.center.revokeAuthorization { [weak self] result in
                switch result {
                case .success():
                    print("Revoke Authorization: success")
                    self?.actualStatus = nil
                    
                case .failure(let error):
                    print("Revoke Authorization: \(error.localizedDescription)")
                    
                    if let error = error as? FamilyControlsError {
                        print("Failure reason: \(String(describing: error.failureReason))")
                        print("Recovery suggestion: \(String(describing: error.recoverySuggestion))")
                        print("Help achor \(String(describing: error.helpAnchor))")
                    }
                }
                
                DispatchQueue.main.async {
                    completionHandler?(result)
                }
            }
        }
    }
    
    // MARK: - KVO & Notifications
    
    private var cancellables: [AnyCancellable] = []
    
    func subscribeForChangesObservation() {
        center.$authorizationStatus.sink { [weak self] newStatus in
            print("Authorization status changed to: \(newStatus)")
            self?.actualStatus = newStatus
        }.store(in: &self.cancellables)
    }
    
    func unsubscribeFromChangesObservation() {}
}
