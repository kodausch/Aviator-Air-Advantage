//
//  DrawPlaneLine.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 13.04.2024.
//

import UIKit

class DrawPlaneLine: UIView {

    // MARK: - Public
    
    var drawingClosure: () -> () = {}
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black
    }
    
    init(closure: @escaping () -> ()) {
        
        self.drawingClosure = closure
        super.init(frame: .zero)
    }
    
    func redraw() {
        self.setNeedsDisplay()
    }
    
    // MARK: - UIView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let graficContext = UIGraphicsGetCurrentContext() {
            graficContext.setFillColor(UIColor.white.cgColor)
            graficContext.clear(rect)
        }
        
        drawingClosure()
    }
 
}
