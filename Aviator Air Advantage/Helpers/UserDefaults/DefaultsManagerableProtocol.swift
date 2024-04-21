//
//  DefaultsManagerable.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation

protocol DefaultsManagerableProtocol {
    func saveObject(value: Any,
                    for key: Constants.DefaultsKeys)
    
    func getObject<T>(type: T.Type,
                        for key: Constants.DefaultsKeys) -> T?
}
