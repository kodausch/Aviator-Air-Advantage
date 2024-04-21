//
//  ImageExplosion.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit

extension UIImageView {
    func explodeAndDisappear() {
        // Загрузка GIF-анимации взрыва
        guard let url = Bundle.main.url(forResource: "explosion",
                                        withExtension: "gif"),
              let imageData = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return
        }
        
        // Получение всех кадров GIF-анимации
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()
        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.removeFromSuperview()
            self.superview?.removeFromSuperview()
        }
        // Настройка анимации
        animationImages = images
        animationDuration = Double(frameCount) * 0.1 // Измените значение 0.1, если необходимо изменить скорость анимации
        animationRepeatCount = 0

        startAnimating()
        
    }
}
