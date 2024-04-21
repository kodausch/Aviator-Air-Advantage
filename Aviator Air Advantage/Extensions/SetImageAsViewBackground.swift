//
//  SetImageAsViewBackground.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation
import UIKit

extension UIView {
    func setBackground() {
        let backgroundImage = UIImage(named: Constants().bgImageName)
        var bgView: UIImageView?
        bgView = UIImageView(frame: self.bounds)
        bgView?.contentMode = UIView.ContentMode.scaleAspectFill
        bgView?.clipsToBounds = true
        bgView?.image = backgroundImage
        bgView?.center = self.center
        self.addSubview(bgView!)
        self.sendSubviewToBack(bgView!)
    }
}
