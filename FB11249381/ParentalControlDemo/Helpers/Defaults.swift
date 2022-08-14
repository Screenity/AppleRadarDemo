//
//  Defaults.swift
//  ParentalControlDemo
//
//  Created by Salavat Khanov on 20.01.2022.
//

import Foundation
import FamilyControls

final class Defaults {
    static let standard = UserDefaults.standard
    static let shared = UserDefaults(suiteName: AppGroupID.sharedAppGroupContainer.rawValue)!
}

extension UserDefaults {
    
    var cachedParentalAuthorizationStatus: AuthorizationStatus? {
        get {
            guard let rawStatus = object(forKey: Key.cachedParentalAuthorizationStatus.rawValue) as? Int else { return nil }
            return AuthorizationStatus(rawValue: rawStatus)
        }
        set {
            set(newValue?.rawValue, forKey: Key.cachedParentalAuthorizationStatus.rawValue)
        }
    }
    
    enum Key: String {
        case cachedParentalAuthorizationStatus
    }
}
