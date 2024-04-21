//
//  TutorView.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 19.03.2024.
//

import Foundation
import UIKit

class TutorView: UIView {
    
    let label = BaseLabel()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.isEnabled = false
        pageControl.currentPage = 0
        pageControl.backgroundStyle = .minimal
        return pageControl
    }()
    
    var nextButton = {
        let button = UIButton()
        button.setTitle(title: " Continue ")
        button.titleLabel?.textColor = .red
        return button
    }()
    
    var texts: [String] = [] {
        didSet {
            pageControl.numberOfPages = texts.count
            if texts.count > selectedPage {
                label.text = texts[selectedPage]
            }
        }
    }
    var selectedPage = 0 {
        didSet {
            pageControl.currentPage = selectedPage
            if texts.count > selectedPage {
                label.text = texts[selectedPage]
            }
            else {
                hide()
            }
        }
    }
    
    init(texts: [String]) {
        super.init(frame: CGRect.zero)
        self.texts = texts
        label.text = texts[0]
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide() {
        DataManager().saveObject(value: false,
                                 for: .tutorAvia)
        [label,
         nextButton,
         self].forEach { view in
            view.isHidden = true
        }
        superview?.removeBlur()
        self.isHidden = true
    }
    
    func setUp() {
        self.backgroundColor = .black.withAlphaComponent(0.75)
        let swipeGesture = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(handleSwipeGesture(_:)))
                swipeGesture.direction = .right
                self.addGestureRecognizer(swipeGesture)
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(handleSwipeGesture(_:)))
        swipeGestureLeft.direction = .left
                self.addGestureRecognizer(swipeGestureLeft)
        [label,
         nextButton,
         pageControl].forEach { subview in
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        pageControl.numberOfPages = texts.count
        
        NSLayoutConstraint.activate([label.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                                  multiplier: 0.8),
                                     label.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                                   multiplier: 0.75),
                                     label.centerXAnchor.constraint(equalTo: self.centerXAnchor,
                                                                    constant: -10),
                                     label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     
                                     nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                                        constant: -12),
                                     
                                     pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor,
                                                                         constant: -12)
        ])
        nextButton.addTarget(self,
                             action: #selector(nextPage),
                             for: .touchUpInside)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .right {
                swipeRightAction()
            } else if gesture.direction == .left {
                swipeLeftAction()
            }
        }
        
        func swipeRightAction() {
            selectedPage = max(selectedPage - 1,
                               0)
        }
        func swipeLeftAction() {
            nextPage()
        }
    
    @objc func nextPage() {
        selectedPage += 1
    }
}

extension UIView {
    func addTutor(_ tutorialView: TutorView) {
        addBlur()
        self.addSubview(tutorialView)
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tutorialView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     tutorialView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     tutorialView.widthAnchor.constraint(equalTo: self.widthAnchor),
                                     tutorialView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                                          multiplier: 0.4)])
    }
}
