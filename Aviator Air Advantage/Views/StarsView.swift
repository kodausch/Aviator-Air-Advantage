//
//  StarsView.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 13.04.2024.
//

import Foundation
import UIKit
import TweenKit

class StarsView: UIView {
    
    // MARK: - Types
    private struct Star {
        var t = 0.0
        let restPosition: CGPoint
        let moveAmount = CGFloat(5.0)
        var startPosition: CGPoint {
            return CGPoint(x: restPosition.x,
                           y: restPosition.y + 80)
        }
        var currentPosition: CGPoint{
            return startPosition.lerp(t: t, 
                                      end: restPosition)
        }
        
        var color: UIColor {
            return .white.withAlphaComponent(0.7)
        }
        
        init(restPosition: CGPoint) {
            self.restPosition = restPosition
        }
    }
    
    // MARK: - Internal
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = UIColor.clear
     
        // Create the stars
        stars = makeStars().sorted{ $0.currentPosition.y < $1.currentPosition.y }
        
        // Create the action
        let duration = 0.35
        var actions = [InterpolationAction<Double>]()
        
        for index in (0..<stars.count) {
            
            let action = InterpolationAction(from: 0.0,
                                             to: 20.0,
                                             duration: duration,
                                             easing: .linear) {
                                                [unowned self] in
                                                self.stars[index].t = $0
            }
            actions.append(action)
        }
        
        let group = ActionGroup(staggered: actions,
                                offset: (0.35 - duration) / Double(actions.count))
        self.sScrubber = ActionScrubber(action: group)
    }
    
    func update(t: Double) {
        sScrubber.update(t: t)
        setNeedsDisplay()
    }
    
    // MARK: - Properties
    
    private var stars: [Star]!
    private var sScrubber: ActionScrubber!
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.clear(rect)
        
        stars.forEach{
            
            $0.color.set()
            
            let radius = CGFloat(3.0)
            let rect = CGRect(x: $0.currentPosition.x - radius,
                              y: $0.currentPosition.y - radius,
                              width: radius*2,
                              height: radius*2)
            
            UIBezierPath(ovalIn: rect).fill()
        }
    }
    
    // MARK: - Methods
    
    private func makeStars() -> [Star] {
        
        var stars = [Star]()
        let numStars = 2000
        
        (0..<numStars).forEach{ _ in
            
            let x = arc4random() % UInt32(bounds.size.width)
            let y = arc4random() % UInt32(bounds.size.height * 3)
            let position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            
            for existingStar in stars {
                
                if position.distanceTo(other: existingStar.restPosition) < 100 {
                    return
                }
            }
        
            let star = Star(restPosition: position)
            stars.append(star)
        }
        return stars
    }
    
    
    
}
