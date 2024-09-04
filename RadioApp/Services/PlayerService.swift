//
//  PlayerService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation
import AVFoundation
import Combine

import Foundation
import AVFoundation
import Combine

final class PlayerService: ObservableObject {
    
    // MARK: - Properties
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timer: AnyCancellable?
    private let updateInterval: TimeInterval = 0.08
    
    // Audio session object
    private let session = AVAudioSession.sharedInstance()
    
    // Observer for volume changes
    private var volumeObserver: NSKeyValueObservation?
    
    @Published var stations = [StationModel]()
    @Published var indexRadio = 0
    @Published var volume: CGFloat = 0.0
    @Published var amplitude: CGFloat = 0.0
    @Published var isPlayMusic = false
    
    // Computed property for current station
    var currentStation: StationModel {
        get {
            guard !stations.isEmpty else {
                return StationModel.testStation()
            }
            return stations[indexRadio]
        }
        set {
            if let newIndex = stations.firstIndex(of: newValue) {
                self.indexRadio = newIndex
            }
        }
    }
    
    // Computed property for current URL
    private var currentURL: String {
        currentStation.url
    }
    
    // MARK: - Initialization
    init() {
        self.volume = CGFloat(session.outputVolume)
        setVolumeObserver()
    }
    
    deinit {
        stopUpdatingAmplitude()
        stopAudioStream()
        unsubscribeVolumeObserver()
        player?.removeObserver(self as! NSObject, forKeyPath: #keyPath(AVPlayer.status))
    }
    
    // MARK: - Add Radio Station to Player
    func addStationForPlayer(_ stations: [StationModel]) {
        self.stations.append(contentsOf: stations)
        indexRadio = min(indexRadio, stations.count - 1)
    }
    
    // MARK: - Audio Playback Methods
    
    /// Plays audio from the current station's URL
    func playAudio() {
        guard let url = URL(string: currentURL) else { return }
        do {
            try session.setCategory(.playback)
            player = AVPlayer(url: url)
            playAudioStream()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Pauses the currently playing audio stream
    func pauseAudioStream() {
        player?.pause()
        isPlayMusic = false
        stopUpdatingAmplitude()
    }
    
    /// Stops the audio stream and releases the player
    func stopAudioStream() {
        isPlayMusic = false
        player = nil
    }
    
    /// Plays the next station in the list
    func nextStationStream() {
        guard !stations.isEmpty else { return }
        indexRadio = (indexRadio + 1) % stations.count
        playAudio()
    }
    
    /// Plays the previous station in the list
    func backTrackAudioStream() {
        guard !stations.isEmpty else { return }
        indexRadio = (indexRadio - 1 + stations.count) % stations.count
        playAudio()
    }
    
    private func playAudioStream() {
        guard !stations.isEmpty else { return }
        player?.play()
        isPlayMusic = true
        startUpdatingAmplitude()
    }
    
    // MARK: - Volume
    
    /// Sets up the volume observer to monitor volume changes
    private func setVolumeObserver() {
        do {
            try session.setCategory(.ambient)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
        volumeObserver = session.observe(\.outputVolume) { [weak self] session, _ in
            DispatchQueue.main.async {
                self?.volume = CGFloat(session.outputVolume)
                print("Current volume value - \(self?.volume ?? 0.0)")
            }
        }
    }
    
    /// Removes the volume observer
    private func unsubscribeVolumeObserver() {
        volumeObserver?.invalidate()
    }
    
    // MARK: - Amplitude
    
    /// Starts updating the amplitude
    private func startUpdatingAmplitude() {
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink {  _ in
                Task { @MainActor [weak self] in
                    self?.amplitude = CGFloat.random(in: 0...1)
                }
            }
    }
    
    /// Stops updating the amplitude
    private func stopUpdatingAmplitude() {
        timer?.cancel()
    }
}
