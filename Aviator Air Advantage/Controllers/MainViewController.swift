//
//  ViewController.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 13.04.2024.
//

import UIKit
import TweenKit

class MainViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    let bulletProvider = BulletProvider()
    
    var resultedPopUp: PopUp?
    
    var outOfMoney: PopUp?
    
    var isClaimed = false
    
    private let scheduler = ActionScheduler(automaticallyAdvanceTime: true)
    
    var tutorial = TutorView(texts: ["Welcome Aviator Air Advantage! To get started, place your bet and press the \"Start\" button.",
                                        "In this game, you need to launch the plane into flight and withdraw your bet in time - at any moment the plane can explode",
                                     "Also, you have to protect the plane from bullets sypmly clicking on them",
                                        "The longer the plane stays in the air - the bigger the winnings, but also the risk",
                                        "Good luck and enjoy the game!"])
    
    var actionScrubber: ActionScrubber?
    
    var isPlaying = false {
        didSet {
            if isPlaying {
                mainButton.setTitle(title: "Claim")
            }
            else {
                mainButton.setTitle(title: "Start")
            }
        }
    }
    
    @IBOutlet weak var topFrameView: UILabel!
    @IBOutlet weak var bottomFrameView: UILabel!
    
    var flightTime = 0.0
    
    var timeLefted = 0.0
    
    var multiplier = 0.0 {
        didSet {
            multiplierLabel.text = String(String("x\(multiplier)").prefix(5))
        }
    }
    
    var balance = 10000 {
        didSet {
            DataManager().saveObject(value: balance,
                                     for: .balance)
            balanceLabel.text = "\(balance)"
        }
    }
    
    var bet = 2000 {
        didSet {
            betLabel.text = "\(bet)"
        }
    }
    
    var mainGameTimer = Timer()
    
    var bulletTimer = Timer()
    
    var planeView = {
        return PlaneView()
    }()
    
    var skyView = {
        return StarsView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainButton()
        labelSetUp()
        
        view.showCharacter(name: "pilot")
        
        balance = DataManager().getObject(type: Int.self,
                                              for: .balance) ?? 10000
        
        isPlaying = false
        
        self.skyView = StarsView()
        self.skyView.layer.opacity = 1

        view.addSubview(skyView)
        view.sendSubviewToBack(skyView)
        bet = 2000
        
        if DataManager().getObject(type: Bool.self,
                                   for: .tutorAvia) ?? true {
            view.addTutor(tutorial)
            DataManager().saveObject(value: false,
                                         for: .tutorAvia)
        }
    }
    
    func setUpMainButton() {
        mainButton.setTitle(title: mainButton.titleLabel!.text!)
        mainButton.backgroundColor = .white
        mainButton.layer.cornerRadius = Constants().cornerRadius
        mainButton.tintColor = .red
        mainButton.clipsToBounds = true
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
    
    func labelSetUp() {
        betLabel.textColor = .white
        betLabel.font = Constants().font
    }
    @IBAction func back(_ sender: Any) {
        bulletTimer.invalidate()
        mainGameTimer.invalidate()
        bulletProvider.cancelBullet()
        NotificationCenter.default.post(name: .balanceNotification,
                                        object: nil)
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func runPlaneButtonFunc(_ sender: Any) {
        if !isPlaying {
            isClaimed = false
            if balance < bet {
                performSegue(withIdentifier: "toMini",
                             sender: nil)
            }
            else {
                
                balance -= bet
                multiplier = 0.0
                skyView.removeFromSuperview()
                
                self.skyView = StarsView()
                self.planeView = PlaneView()
                
                self.planeView.layer.opacity = 1
                self.skyView.layer.opacity = 1
                
                view.addSubview(planeView)
                view.addSubview(skyView)
                view.sendSubviewToBack(skyView)
                view.sendSubviewToBack(planeView)
                
                skyView.translatesAutoresizingMaskIntoConstraints = false
                planeView.translatesAutoresizingMaskIntoConstraints = false
                
                planeView.frame = view.bounds
                skyView.frame = view.bounds
                
                
                isPlaying = true
                flightTime = Double.random(in: 7.0...19.0)
                timeLefted = flightTime
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    self.bulletTimer = Timer.scheduledTimer(withTimeInterval: 2,
                                                       repeats: true) { T in
                        let targetPoint = CGPoint(x: 320,
                                                  y: 260)
                        if !self.isClaimed {
                            self.bulletProvider.fireBullet(from: CGPoint(x: Int.random(in: 0...200),
                                                                         y: Int(UIScreen.main.bounds.height) - 200),
                                                           image: UIImage(named: "bullet")!,
                                                           to: targetPoint,
                                                           completion: {
                                self.showBulletFlightResult()
                                self.bulletProvider.cancelBullet()
                                T.invalidate()
                            }, cancelation: {
                                
                            })
                        }
                    }
                }
                mainGameTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                                     repeats: true,
                                                     block: { T in
                    self.multiplier += 0.03
                    self.timeLefted -= 0.1
                    if self.timeLefted <= 0 {
                        self.isClaimed = true
                        self.resultedPopUp = PopUp(withText: "Sorry, but you lose: the plane was exploded!")
                        self.resultedPopUp?.popUpCentreButton.addTarget(self,
                                                                        action: #selector(self.hidePopUp),
                                                                   for: .touchUpInside)
                        
                        self.multiplier = 0.0
                        self.scheduler.step(dt: 100.0)
                        self.planeView.planeImageView.explodeAndDisappear()
                        self.mainGameTimer.invalidate()
                        self.bulletTimer.invalidate()
                        self.bulletProvider.cancelBullet()
                        self.mainButton.isEnabled = false
                        UIView.animate(withDuration: 0.8) {
                            self.planeView.layer.opacity = 0
                            self.skyView.layer.opacity = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.view.presentPopUp(popUp: self.resultedPopUp!)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            self.isPlaying = false
                            self.mainButton.isEnabled = true
                            self.planeView.removeFromSuperview()
                            self.skyView.removeFromSuperview()
                        }
                    }
                })
                mainGameTimer.fire()
                runPlane()
            }
        }
        else {
            isClaimed = true
            bulletTimer.invalidate()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.playSound(sound: .pick)
            }
            
            bulletProvider.cancelBullet()
            
            balance += Int(Double(bet) * multiplier)
            resultedPopUp = PopUp(withText: "Congrats! Your bet was multiplied by \(String(String("x\(multiplier)").prefix(5)))!")
            resultedPopUp?.popUpCentreButton.addTarget(self,
                                                       action: #selector(hidePopUp),
                                                       for: .touchUpInside)
            mainGameTimer.invalidate()
            bulletTimer.invalidate()
            mainButton.isEnabled = false
            UIView.animate(withDuration: 2.0) {
                self.planeView.layer.opacity = 0
                self.skyView.layer.opacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.view.presentPopUp(popUp: self.resultedPopUp!)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.mainButton.isEnabled = true
                self.isPlaying = false
                self.planeView.removeFromSuperview()
                self.skyView.removeFromSuperview()
            }
        }
    }
    
    private func showBulletFlightResult() {
        self.resultedPopUp = PopUp(withText: "Sorry, but you lose: the plane was exploded!")
        self.resultedPopUp?.popUpCentreButton.addTarget(self,
                                                        action: #selector(self.hidePopUp),
                                                        for: .touchUpInside)
        
        self.multiplier = 0.0
        self.scheduler.step(dt: 100.0)
        self.planeView.planeImageView.explodeAndDisappear()
        self.mainGameTimer.invalidate()
        self.bulletTimer.invalidate()
        self.mainButton.isEnabled = false
        UIView.animate(withDuration: 0.8) {
            self.planeView.layer.opacity = 0
            self.skyView.layer.opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.presentPopUp(popUp: self.resultedPopUp!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.isPlaying = false
            self.mainButton.isEnabled = true
            self.planeView.removeFromSuperview()
            self.skyView.removeFromSuperview()
        }
        self.planeView.planeImageView.explodeAndDisappear()
    }
    
    @objc func toMiniGame() {
        performSegue(withIdentifier: "toMini",
                     sender: nil)
    }
    
    @objc func hidePopUp() {
        resultedPopUp?.dismiss(animated: true)
        multiplier = 0.0
    }
    
    @IBAction func minusFunc(_ sender: Any) {
        if bet > 2000 {
            bet -= 1000
        }
    }
    @IBAction func plusFunc(_ sender: Any) {
        if balance > bet {
            bet += 1000
        }
    }
    
    func runPlane() {
        
        let planeAction = InterpolationAction(from: 0.0,
                                              to: 1.0,
                                              duration: 8.0,
                                              easing: .linear) {
            [unowned self] in
            self.planeView.setRocketAnimationPct(t: $0)
        }
        
        let starsAction = InterpolationAction(from: 0.0,
                                              to: 1.0,
                                              duration: 13.0,
                                              easing: .linear) {
            [unowned self] in
            self.skyView.update(t: $0)
        }
        
        planeAction.easing = .linear
        starsAction.duration = 30
        
        scheduler.run(action: planeAction)
        scheduler.run(action: starsAction)
    }
}

