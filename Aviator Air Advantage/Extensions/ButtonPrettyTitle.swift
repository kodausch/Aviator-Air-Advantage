//
//  ButtonPrettyTitle.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation
import UIKit
import SwiftyButton

extension UIButton {
    func setTitle(title: String) {
        if #available(iOS 15.0, *) {
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : Constants().font!,
                                                              NSAttributedString.Key.languageIdentifier : "123"]
            self.setAttributedTitle(NSAttributedString(string: title,
                                                       attributes: attributes),
                                      for: .normal)
        } else {
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : Constants().font!]
            self.setAttributedTitle(NSAttributedString(string: title,
                                                       attributes: attributes),
                                      for: .normal)
        }
    }
}

extension BaseButton {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        setTitle(title: title ?? "")
    }
}

extension CustomPressableButton {
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        setTitle(title: title ?? "")
    }
}
