//
//  BulletView.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 19.04.2024.
//

import Foundation
import UIKit

class BulletView: UIImageView {
    var completion: (() -> Void)?
    var cancelation: (() -> Void)?
    var targetPoint: CGPoint = .zero
    var animation: UIViewPropertyAnimator?
    
    override init(image: UIImage?) {
        super.init(image: image)
        isUserInteractionEnabled = true 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(to targetPoint: CGPoint, completion: @escaping () -> Void, cancelation: @escaping () -> Void) {
        self.completion = completion
        self.cancelation = cancelation
        self.targetPoint = targetPoint
        
        let angle = atan2(targetPoint.y - self.center.y, targetPoint.x - self.center.x)
               self.transform = CGAffineTransform(rotationAngle: angle - .pi/2).scaledBy(x: -1, y: -1) 
        
        animation = UIViewPropertyAnimator(duration: 2.0, curve: .linear) {
            self.center = targetPoint
        }
        animation?.addCompletion { [weak self] _ in
            guard let self = self else { return }
            completion()
            self.removeFromSuperview()
        }
        animation?.startAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelation?()
        animation?.stopAnimation(true)
        removeFromSuperview()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let window = UIApplication.shared.windows.first else { return }
        self.center.x = min(max(self.center.x, 0), window.bounds.width)
        self.center.y = min(max(self.center.y, 0), window.bounds.height)
    }
}
