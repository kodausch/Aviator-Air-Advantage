//
//  StackArrangedSVs.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .equalSpacing
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}

