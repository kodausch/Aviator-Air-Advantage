//
//  DefaulysManager.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation

final class DataManager {
    private let defaultsStandart = UserDefaults.standard
}

extension DataManager: DefaultsManagerableProtocol {
    public func saveObject(value: Any,
                           for key: Constants.DefaultsKeys) {
        defaultsStandart.set(value,
            forKey: key.rawValue)
    }
    public func getObject<T>(type: T.Type,
                               for key: Constants.DefaultsKeys) ->T? {
        return defaultsStandart.object(forKey: key.rawValue) as? T
    }
}

