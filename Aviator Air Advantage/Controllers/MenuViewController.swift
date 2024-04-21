//
//  MenuViewController.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import UIKit
import SwiftyButton

class MenuViewController: UIViewController {

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var settingsButton: BaseButton!
    @IBOutlet weak var helpButton: CustomPressableButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var playAviatorButton: CustomPressableButton!
    @IBOutlet weak var playPlaneFastTrackButton: CustomPressableButton!
    
    var balance = DataManager().getObject(type: Int.self,
                                          for: .balance) ?? 10000 {
        didSet {
            balanceLabel.text = "\(balance)"
        }
    }
    
    var settingsPopUp: PopUp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
        setUp()
        checkDailyBonus()
    }
    
    @IBAction func helpAction(_ sender: Any) {
        DataManager().saveObject(value: true,
                                 for: .tutorAvia)
        performSegue(withIdentifier: "main",
                     sender: nil)
    }
    
    func checkDailyBonus() {
        let lastDay = DataManager().getObject(type: Int.self,
                                for: .date) ?? -1
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if let day = components.day {
            if day != lastDay {
                DataManager().saveObject(value: day,
                                         for: .date)
                let popUP = PopUp(dailyBonusAmount: 10000)
                view.presentPopUp(popUp: popUP)
            }
        }
    }
    
    func setUp() {
        [settingsButton,
         helpButton,
         playAviatorButton,
         playPlaneFastTrackButton].forEach { button in
            button!.setTitle(title: (button?.titleLabel!.text!)!)
            button?.layer.cornerRadius = Constants().cornerRadius
            button?.clipsToBounds = true
            button?.colors = .init(button: .white,
                                   shadow: .red.withAlphaComponent(0.2))
            button?.shadowHeight = 5
        }
        
        frameView.layer.cornerRadius = Constants().cornerRadius
        frameView.clipsToBounds = true
        
        view.setBackground()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewDidBecomeActive),
                                               name: .balanceNotification,
                                               object: nil)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if DataManager().getObject(type: Bool.self,
                                       for: .musicIsOn) ?? false {
                appDelegate.playSound(sound: .bg)
            }
            }
    }
    @IBAction func settingsButtonFunc(_ sender: Any) {
        showSettings()
    }
    
    @objc func viewDidBecomeActive() {
        view.removeBlur()
        balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
    }
    
    @objc func showSettings() {
        settingsPopUp?.removeFromSuperview()
        settingsPopUp = PopUp(music: "")
        settingsPopUp!.popUpCentreButton.addTarget(self,
                                           action: #selector(hidePopUp),
                                           for: .touchUpInside)
        view.presentPopUp(popUp: settingsPopUp!)
    }
    
    @objc func hidePopUp() {
        settingsPopUp?.dismiss(animated: true)
    }

}
