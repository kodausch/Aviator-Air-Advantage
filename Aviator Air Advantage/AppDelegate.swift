//
//  AppDelegate.swift
//  Aviator Air Advantage
//
//  Created by Nikita Stepanov on 13.04.2024.
//

import UIKit
import AVFAudio
import AVFoundation

@main
class AppDelegate: UIResponder,
                   UIApplicationDelegate {
    var winPlayer = SoundPlayer(numberOfLoops: 0,
                                      soundName: .win,
                                      soundType: .mp3)
    
    var pickPlayer = SoundPlayer(numberOfLoops: 0,
                                 soundName: .pick,
                               soundType: .mp3)
    
    var bgPlayer = SoundPlayer(numberOfLoops: -1,
                               soundName: .bg,
                               soundType: .mp3)
    
    var explosionPlayer = SoundPlayer(numberOfLoops: 0,
                                      soundName: .explosion,
                                  soundType: .mp3)
    
    static var orientation = UIInterfaceOrientationMask.portrait
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    // MARK: - sounds funcs
    
    public func playSound(sound name: SoundsNames) {
        switch name {
        case .bg:
            bgPlayer.player!.prepareToPlay()
            bgPlayer.player!.play()
        case .win:
            winPlayer.player!.prepareToPlay()
            winPlayer.player!.play()
        case .pick:
            pickPlayer.player!.prepareToPlay()
            pickPlayer.player!.play()
        case .explosion:
            explosionPlayer.player!.prepareToPlay()
            explosionPlayer.player!.play()
        }
    }
    
    public func stopSound(sound name: SoundsNames) {
        switch name {
        case .bg:
            bgPlayer.player!.stop()
        case .explosion:
            explosionPlayer.player!.stop()
        case .win:
            winPlayer.player!.stop()
        case .pick:
            pickPlayer.player!.stop()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientation
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

