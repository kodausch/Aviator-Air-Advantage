//
//  PlaneView.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 13.04.2024.
//

import TweenKit
import UIKit

class PlaneView: UIView {
    
    var a = Double.random(in: 0.1...0.25)
    var c = Double.random(in: 0.2...0.35)
    var b = Double(Int.random(in: -1...1))
    
    // MARK: - Internal
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        isUserInteractionEnabled = false
        
        // Set draw closure
        drawPathView.drawingClosure = {
            [unowned self] in
            
            UIColor.red.set()
            self.path.stroke()
            
            UIColor.clear.set()
            let rect = CGRect(x: self.planeImageView.center.x,
                                   y: 0,
                                   width: self.bounds.size.width - self.planeImageView.center.x,
                                   height: self.bounds.size.height)
            UIRectFill(rect)
        }
    
        addSubview(planeImageView)
        addSubview(drawPathView)
        sendSubviewToBack(drawPathView)

        
        let action = BezierAction(path: path.asBezierPath(),
                                  duration: 0.4) {
                                    [unowned self] (pos,
                                                    rotation) in
            
                                    self.planeImageView.center = pos
                                    
                                    let planeRotation = CGFloat(rotation.value)
                                    self.planeImageView.transform = CGAffineTransform(rotationAngle: planeRotation)
                                    
                                    self.drawPathView.redraw()
        }
        
        actionScrubber = ActionScrubber(action: action)
        
        setRocketAnimationPct(t: 0.0)
        
        drawPathView.frame = bounds
    }
    
    func setRocketAnimationPct(t: Double) {
        
        guard let scrubber = actionScrubber else {
            return
        }
        
        // Fade out the trail at the end
        let trailFadeTime = 0.2
        if t < 1 - trailFadeTime {
            drawPathView.alpha = 1.0
        }
        
        let additional = 0.1
        let minT = t - additional
        let maxT = t + additional
        let newT = minT + ((maxT - minT) * t)
        
        scrubber.update(t: newT)
    }
    
    // MARK: - Properties
    
    private var actionScrubber: ActionScrubber?
    
    private let drawPathView: DrawPlaneLine = {
        let view = DrawPlaneLine()
        view.tintColor = .orange
        return view
    }()
    
    public let planeImageView: UIImageView = {
        let image = UIImage(named: "plane")!
        let imageView = UIImageView(image: image)
        let scale = CGFloat(0.2)
        imageView.frame.size = CGSize(width: 70,
                                      height: 70)
        return imageView
    }()
    
    private var path: UIBezierPath {
        
        let controlPointsYOffset = bounds.width * a
        let endPointsYOffset = bounds.size.width * c
        
        let start = CGPoint(x: 60,
                            y: bounds.size.height/2 + 3 * endPointsYOffset)
        let control1 = CGPoint(x: bounds.size.width/3,
                               y: bounds.size.height/2 - 0.5 * controlPointsYOffset)
        let control2 = CGPoint(x: bounds.size.width/3*1.5,
                               y: bounds.size.height/2 + b * controlPointsYOffset)
        let end = CGPoint(x: bounds.size.width - 90,
                          y: bounds.size.height/2 - endPointsYOffset - bounds.size.width*0.1)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
        return path
    }
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
