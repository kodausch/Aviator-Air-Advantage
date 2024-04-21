//
//  PlaneVPPProtocol.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 17.04.2024.
//

import Foundation

protocol PlaneVPPProtocol {
    func runPlane(from: Position,
                  complition: @escaping (Bool) -> Void)
}
