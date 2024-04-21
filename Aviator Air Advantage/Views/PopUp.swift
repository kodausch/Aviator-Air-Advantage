//
//  PopUp.swift
//  AttentionFortuneWheel
//
//  Created by Nikita Stepanov on 18.03.2024.
//

import Foundation
import UIKit
import FFPopup

final class PopUp: FFPopup {
    
    public let popUpLabel = BaseLabel()
    
    public let popUpCentreButton: BaseButton = {
        let button = BaseButton()
        button.colors = .init(button: .white,
                              shadow: .red.withAlphaComponent(0.8))
        button.titleLabel?.textColor = .red
        button.cornerRadius = Constants().cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    public let popUpStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.insetsLayoutMarginsFromSafeArea = true
        stack.distribution = .equalSpacing
        return stack
    }()
    
    public let popUpHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.insetsLayoutMarginsFromSafeArea = true
        stack.distribution = .fillEqually
        return stack
    }()
    public let musicLabel: BaseLabel = {
        let musicLabel = BaseLabel()
        musicLabel.text = "Music:"
        musicLabel.textColor = .white
        return musicLabel
    }()
    
    public let soundsLabel: BaseLabel = {
        let soundsLabel = BaseLabel()
        soundsLabel.text = "Sounds:"
        soundsLabel.textColor = .white
        return soundsLabel
    }()
    public let musicSwitch = {
        let swich = UISwitch()
        swich.onTintColor = .white.withAlphaComponent(0.5)
        return swich
    }()
    
    public let soundsSwitch = {
        let swich = UISwitch()
        swich.onTintColor = .white.withAlphaComponent(0.5)
        return swich
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(music: String?) {
        super.init(frame: CGRect.zero)
        standartLayout()
        let text = "Settings:"
        popUpHorizontalStack.distribution = .fill
        popUpHorizontalStack.addArrangedSubviews([musicLabel,
                                                 musicSwitch,
                                                 soundsLabel,
                                                 soundsSwitch])
        
        popUpStack.addArrangedSubviews([popUpLabel,
                                       popUpHorizontalStack,
                                       popUpCentreButton])
        
        musicSwitch.addTarget(self,
                              action: #selector(checkMusic),
                              for: .valueChanged)
        musicSwitch.isOn = DataManager().getObject(type: Bool.self,
                                                   for: .musicIsOn) ?? false
        
        soundsSwitch.addTarget(self,
                               action: #selector(checkSounds),
                               for: .valueChanged)
        soundsSwitch.isOn = DataManager().getObject(type: Bool.self,
                                                    for: .soundsIsOn) ?? false
        popUpLabel.text = text
        popUpLabel.textColor = .white
        popUpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        popUpCentreButton.setTitle(title: "Apply")
        popUpCentreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
       

    }
    
    init(withText text: String) {
        super.init(frame: CGRect.zero)
        standartLayout()
        popUpStack.addArrangedSubviews([popUpLabel,
                                       popUpCentreButton])
        popUpCentreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        popUpLabel.text = "\(text)"
        popUpCentreButton.setTitle(title: "Continue")
    }
    
    init(dailyBonusAmount: Int) {
        super.init(frame: CGRect.zero)
        standartLayout()
        popUpStack.addArrangedSubviews([popUpLabel,
                                       popUpCentreButton])
        popUpCentreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        popUpLabel.text = "Welcome to our game! This is your daily bonus - 10,000 coins!"
        popUpCentreButton.setTitle(title: "Claim")
        popUpCentreButton.addTarget(self,
                                    action: #selector(payBonus),
                                    for: .touchUpInside)
    }
    
    private func standartLayout() {
        popUpLabel.textColor = .white
        self.backgroundColor = .red.withAlphaComponent(0.45)
        self.layer.cornerRadius = 20
        self.contentView = popUpStack
        self.showType = .bounceInFromLeft
        self.dismissType = .bounceOutToRight
        
        popUpLabel.textAlignment = .center
        
        popUpStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([popUpStack.heightAnchor.constraint(equalToConstant: 200),
                                     popUpStack.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc func payBonus() {
        let balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
        DataManager().saveObject(value: balance + 10000,
                                 for: .balance)
        NotificationCenter.default.post(name: .balanceNotification,
                                        object: nil)
        self.dismiss(animated: true)
    }
    
    @objc func checkMusic() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if musicSwitch.isOn {
                appDelegate.playSound(sound: .bg)
                DataManager().saveObject(value: true,
                                         for: .musicIsOn)
            }
            else {
                appDelegate.stopSound(sound: .bg)
                DataManager().saveObject(value: false,
                                         for: .musicIsOn)
            }
        }
    }
    
    @objc func checkSounds() {
        if soundsSwitch.isOn {
            DataManager().saveObject(value: true,
                                     for: .soundsIsOn)
        }
        else {
            DataManager().saveObject(value: false,
                                     for: .soundsIsOn)
        }
    }
}


extension UIView {
    func presentPopUp(popUp: PopUp) {
        let layout = FFPopupLayout(horizontal: .center,
                                   vertical: .center)
        popUp.show(layout: layout)
    }
}
