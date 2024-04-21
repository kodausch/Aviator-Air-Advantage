//
//  PlaneVPPView.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 17.04.2024.
//

import Foundation
import UIKit

class PlaneVPPView: UIProgressView {
    
    // MARK: - Properties
    
    private var timer: Timer?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: Constants.iconSize,
                                                  height: Constants.iconSize))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let finishImageView: UIImageView = {
        let image = UIImage(named: "finish")
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: Constants.iconSize,
                                                  height: Constants.iconSize))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        return imageView
    }()
    
    // MARK: - Common Initialization
    
    private func commonInit() {
        addSubview(iconImageView)
        addSubview(finishImageView)
    }
    
    public func setUp(icon: UIImage) {
        commonInit()
        iconImageView.image = icon
    }
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateIconPosition()
    }
    
    private func updateIconPosition() {
        let progressBarWidth = frame.size.width * CGFloat(progress)
        let iconXPosition = progressBarWidth - Constants.iconSize
        iconImageView.frame = CGRect(x: iconXPosition + Constants.iconInset,
                                     y: -Constants.iconInset,
                                     width: Constants.iconSize,
                                     height: Constants.iconSize)
    }
    
    // MARK: - Public Methods
    
    func setIcon(_ image: UIImage?) {
        iconImageView.image = image
        updateIconPosition()
    }
    
    func setFinishLine(position: Position) {
        let progressBarWidth = frame.size.width
        switch position {
        case .start:
            finishImageView.frame = CGRect(x: progressBarWidth - Constants.iconSize,
                                         y: -Constants.iconSize,
                                         width: Constants.iconSize,
                                         height: Constants.iconSize)
            finishImageView.image = flipImage(finishImageView.image!)
        case .end:
            let iconXPosition = Constants.iconSize
            finishImageView.frame = CGRect(x: 0,
                                         y: -Constants.iconSize,
                                         width: Constants.iconSize,
                                         height: Constants.iconSize)
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let iconSize: CGFloat = 45.0
        static let iconInset: CGFloat = 22.5
    }
    
    private func flipImage(_ image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: image.size.width, y: 0)
        context?.scaleBy(x: -1.0, y: 1.0)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
    
}

extension PlaneVPPView: PlaneVPPProtocol {
    func runPlane(from: Position,
                  complition: @escaping (Bool) -> Void) {
        let randomSpeed = Double.random(in: 1...3)
        switch from {
        case .start:
            var progress = 0.0
            timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                        repeats: true) { T in
                progress += Double(randomSpeed / 100)
                self.progress = Float(progress)
                if progress >= 1.0 {
                    self.timer?.invalidate()
                    complition(true)
                }
            }
            timer?.fire()
        case .end:
            var progress = 1.0
            timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                              repeats: true) { T in
                progress -= Double(randomSpeed / 100)
                self.progress = Float(progress)
                if progress <= 0.0 {
                    self.timer?.invalidate()
                    complition(true)
                }
            }
            timer?.fire()
        }
    }
    
    func stopPlane() {
        timer?.invalidate()
    }
    
    override var progress: Float {
        didSet {
            updateIconPosition()
        }
    }
}

enum Position {
    case start
    case end
}
