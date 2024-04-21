//
//  Constants.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import UIKit

class Constants {
    // fonts
    let fontName = "Verdana Bold"
    let font = UIFont(name: "Verdana Bold",
                      size: 16)
    // common
    let cornerRadius = 18.0
    
    let balance = "balance"
    
    let bgImageName = "bg"
    
    // user defaults
    enum DefaultsKeys: String {
        case tutorAvia
        case tutorBig
        case balance
        case musicIsOn
        case soundsIsOn
        case date
    }
}
