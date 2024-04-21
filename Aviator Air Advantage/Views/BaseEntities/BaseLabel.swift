//
//  BaseLabel.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit

final class BaseLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        font = Constants().font
        textAlignment = .center
        numberOfLines = 0
        textColor = .red
        layer.cornerRadius = Constants().cornerRadius
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
