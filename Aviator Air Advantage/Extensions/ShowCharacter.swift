//
//  ShowCharacter.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit

extension UIView {
    func showCharacter(name: String) {
          let imageView = UIImageView(image: UIImage(named: name))
            imageView.frame = CGRect(x: self.bounds.width,
                                     y: self.bounds.height - 120,
                                     width: 200,
                                     height: 200)
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            
            UIView.animate(withDuration: 2, animations: {
                imageView.frame = CGRect(x: UIScreen.main.bounds.width - 180,
                                         y: UIScreen.main.bounds.height - 320,
                                         width: 200,
                                         height: 200)
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 2, animations: {
                        imageView.alpha = 0 // Постепенно устанавливаем прозрачность на ноль
                    }, completion: { _ in
                        imageView.removeFromSuperview()
                    })
                }
            }
    }
}
