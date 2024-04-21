//
//  BulletProvider.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 19.04.2024.
//

import Foundation
import UIKit

class BulletProvider {
    private var bullet: BulletView?
       
       func fireBullet(from startPoint: CGPoint,
                       image: UIImage,
                       to targetPoint: CGPoint,
                       completion: @escaping () -> Void,
                       cancelation: @escaping () -> Void) {
           bullet = BulletView(image: image)
           bullet?.frame = CGRect(x: startPoint.x,
                                  y: startPoint.y,
                                  width: 40,
                                  height: 40)
           if let keyWindow = UIApplication.shared.windows.first {
               keyWindow.addSubview(bullet!)
           }
           bullet?.fire(to: targetPoint, completion: {
               completion()
           }, cancelation: cancelation)
       }
    
    func cancelBullet() {
            bullet?.animation?.stopAnimation(true)
            bullet?.removeFromSuperview() 
        }
}

