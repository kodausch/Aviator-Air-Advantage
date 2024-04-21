//
//  MiniBetGameViewController.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 17.04.2024.
//

import UIKit

class MiniBetGameViewController: UIViewController {
    
    var balance = 10000 {
        didSet {
            DataManager().saveObject(value: balance,
                                     for: .balance)
            balanceLabel.text = "\(balance)"
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var betBottomButton: UIButton!
    @IBOutlet weak var betTopButton: UIButton!
    @IBOutlet weak var bottomPlane: PlaneVPPView!
    @IBOutlet weak var topPlane: PlaneVPPView!
    
    var tutorial = TutorView(texts: ["This is a free mini-game. Here you can earn money for betting in the main game",
                                    "Just choose top or bottom plane and see which one will arrive first",
                                     "If the plane you chosen arrive first, you will win 5000 coins!"])
    
    var resultPopUp: PopUp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTutor(tutorial)
        balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
        planesSetUp()
        setUpButtons()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewDidBecomeActive),
                                               name: .balanceNotification,
                                               object: nil)
    }
    
    @objc func viewDidBecomeActive() {
        view.removeBlur()
        balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
        balanceLabel.text = "\(balance)"
    }
    
    
    func planesSetUp() {
        topPlane.setUp(icon: UIImage(named: "plane")!)
        topPlane.setFinishLine(position: .start)
        bottomPlane.setUp(icon: UIImage(named: "plane2")!)
        bottomPlane.setFinishLine(position: .end)
    }
    
    @IBAction func betTopFunc(_ sender: Any) {
        betBottomButton.isEnabled = false
        betTopButton.isEnabled = false
        topPlane.runPlane(from: .start) { _ in
            self.bottomPlane.stopPlane()
            self.resultPopUp = PopUp(withText: "Congrats, the top plane arrived first! You won 5000!")
            self.resultPopUp?.popUpCentreButton.addTarget(self,
                                                          action: #selector(self.removePopUP),
                                                          for: .touchUpInside)
            self.view.presentPopUp(popUp: self.resultPopUp!)
            self.balance += 5000
        }
        bottomPlane.runPlane(from: .end) { _ in
            self.topPlane.stopPlane()
            self.resultPopUp = PopUp(withText: "Unfortunately, the top plane arrived first :(")
            self.resultPopUp?.popUpCentreButton.addTarget(self,
                                                          action: #selector(self.removePopUP),
                                                          for: .touchUpInside)
            self.view.presentPopUp(popUp: self.resultPopUp!)
        }
    }
    
    func setUpButtons() {
        [betTopButton,
         betBottomButton].forEach { button in
            button?.setTitle(title: button?.titleLabel?.text ?? "")
            button?.layer.cornerRadius = Constants().cornerRadius
            button?.clipsToBounds = true
        }
    }
    

    @IBAction func betBottomFunc(_ sender: Any) {
        betBottomButton.isEnabled = false
        betTopButton.isEnabled = false
        topPlane.runPlane(from: .start) { _ in
            self.bottomPlane.stopPlane()
            self.resultPopUp = PopUp(withText: "Unfortunately, the top plane arrived first :(")
            self.resultPopUp?.popUpCentreButton.addTarget(self,
                                                          action: #selector(self.removePopUP),
                                                          for: .touchUpInside)
            self.view.presentPopUp(popUp: self.resultPopUp!)
        }
        bottomPlane.runPlane(from: .end) { _ in
            self.topPlane.stopPlane()
            self.resultPopUp = PopUp(withText: "Congrats, the bottom plane arrived first! You won 5000!")
            self.resultPopUp?.popUpCentreButton.addTarget(self,
                                                          action: #selector(self.removePopUP),
                                                          for: .touchUpInside)
            
            self.view.presentPopUp(popUp: self.resultPopUp!)
            self.balance += 5000
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        NotificationCenter.default.post(name: .balanceNotification,
                                        object: nil)
        self.dismiss(animated: true)
    }
    @objc func removePopUP() {
        resultPopUp?.dismiss(animated: true)
        betBottomButton.isEnabled = true
        betTopButton.isEnabled = true
    }

}
