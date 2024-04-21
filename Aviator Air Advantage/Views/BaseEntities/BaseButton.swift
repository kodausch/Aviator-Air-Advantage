//
//  BaseButton.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit
import SwiftyButton

class BaseButton: PressableButton {
    
    public func config() {
        colors = .init(button: .red,
                       shadow: .systemPink)
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = Constants().cornerRadius
        clipsToBounds = true
        titleLabel?.textColor = .red
        backgroundColor = .white
    }
}
