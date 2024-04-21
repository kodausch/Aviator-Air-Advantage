//
//  AddBlurForView.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation
import UIKit

extension UIView {
    func addBlur() {
        let blurEffectView = UIVisualEffectView(effect: nil)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth,
                                           .flexibleHeight]
        UIView.animate(withDuration: 0.3) {
            blurEffectView.effect = UIBlurEffect(style: .systemChromeMaterialDark)
        }
        
        self.addSubview(blurEffectView)
    }
    
    func removeBlur() {
        self.subviews.forEach { subView in
            if subView.frame == self.bounds && subView.autoresizingMask == [.flexibleWidth,
                                                                  .flexibleHeight] {
                UIView.animate(withDuration: 0.3) {
                    subView.layer.opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    subView.removeFromSuperview()
                }
            }
        }
    }
}
