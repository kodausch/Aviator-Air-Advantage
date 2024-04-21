//
//  SoundPlayer.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 14.04.2024.
//

import Foundation
import AVFAudio

final class SoundPlayer: NSObject {
    
    var player: AVAudioPlayer?
    
    init(numberOfLoops: Int,
         soundName: SoundsNames,
         soundType: SoundsTypes) {
        guard
            let bgSoundURL = Bundle.main.url(forResource: soundName.rawValue,
                                                     withExtension: soundType.rawValue)
        else {
            return
        }
        
        player = try? AVAudioPlayer(contentsOf: bgSoundURL)
        
        player?.volume = 0.8
        player?.numberOfLoops = numberOfLoops
    }
}
