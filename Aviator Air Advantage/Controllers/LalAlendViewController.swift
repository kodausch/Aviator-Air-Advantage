//
//  LalAlendViewController.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 15.04.2024.
//

import UIKit
import ProgressHUD


class LalAlendViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        animationLoading()
    }
    
    private func appearance() {
        view.setBackground()
    }
    
    private func animateDI() {
        ProgressHUD.animationType = .squareCircuitSnake
        ProgressHUD.colorAnimation = .red
        ProgressHUD.colorBackground = .black.withAlphaComponent(0.6)
        ProgressHUD.colorHUD = .black.withAlphaComponent(0.6)
        ProgressHUD.animate()
    }
    
    private func animationLoading() {
        animateDI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            ProgressHUD.dismiss()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.performSegue(withIdentifier: "toMain",
                              sender: nil)
        }
    }
}
