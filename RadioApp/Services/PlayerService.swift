//
//  PlayerService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation
import AVFoundation
import Combine

final class PlayerService {
    // MARK: - Constants
    static let shared = PlayerService()

    // MARK: - Properties
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?

    private var currentURL: String?
    
    @Published var volume = AVAudioSession.sharedInstance().outputVolume {
        didSet {
            player?.volume = volume
        }
    }
   
    let session = AVAudioSession.sharedInstance()

    // MARK: - Initialization
    private init() {}

    // MARK: - Audio Playback Methods
    func playAudio(url: String) {
        guard let url = URL.init(string: url) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            
            player = AVPlayer(url: url)
            player?.play()
        } catch let err {
            print(err.localizedDescription)
        }
    }

    func loadPlayer(from episode: StationModel) {
        guard let musicURL = URL(string: episode.url) else {
            print("Invalid music URL")
            return
        }
        
        playerItem = AVPlayerItem(url: musicURL)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = volume
        player?.play()
        currentURL = episode.url
    }

    func playMusicWithURL(_ episode: StationModel) {
        if isPlayingMusic(from: episode.url) {
            pauseMusic()
        } else {
            loadPlayer(from: episode)
            currentURL = episode.url
        }
    }

    func playMusic() {
        player?.play()
    }

    func pauseMusic() {
        player?.pause()
    }

    func stopMusic() {
        player?.pause()
        player = nil
        currentURL = nil
    }

    // MARK: - Utility Functions

    private func isPlayingMusic(from url: String) -> Bool {
        return currentURL == url && player?.rate != 0 && player?.error == nil
    }

    // MARK: - Helper Function (Commented Out)

    //func isPlayerPerforming() -> Bool {
    //    return player?.timeControlStatus == .playing ? true : false
    //}

}
