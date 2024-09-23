//
//  PlayerService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation
import AVFoundation
import Combine
import MediaPlayer

// MARK: - PlayerService
// A service class responsible for managing audio playback using AVPlayer
final class PlayerService: ObservableObject {
    static let shared = PlayerService()
    // MARK: - Properties
    
    // AVPlayer instance for streaming audio
    var player: AVPlayer?
    
    // AVPlayerItem instance, not used directly in this class
    private var playerItem: AVPlayerItem?
    
    // Timer for periodically updating the amplitude
    private var timer: AnyCancellable?
    
    // Interval for amplitude updates
    private let updateInterval: TimeInterval = 0.08
    
    // Audio session object for managing audio configurations
    private let session = AVAudioSession.sharedInstance()
    
    // Observer for volume changes
    private var volumeObserver: NSKeyValueObservation?
    
    // Published properties to update UI or other observers
    @Published var stations = [StationModel]()
    @Published var indexRadio: Int? = nil
    @Published var volume: Float = 1.0
    @Published var systemVolume: Float = 1.0
    @Published var amplitude: CGFloat = 0.0
    @Published var isPlayMusic = false
    
    // Computed property to get or set the current station
    var currentStation: StationModel? {
        get {
            guard !stations.isEmpty else {
                return StationModel.testStation()
            }
            guard let indexRadio else { return nil }
            return stations[indexRadio]
        }
        set {
            if let newStation = newValue, let newIndex = stations.firstIndex(of: newStation) {
                self.indexRadio = newIndex
            }
        }
    }
    
    // Computed property to get the URL of the current station
    private var currentURL: String {
        currentStation?.url ?? ""
    }
    
    // MARK: - Initialization
    // Initializes the PlayerService and sets up the volume observer
    private init() {
        configureAudioSession()
        setVolumeObserver()
    }
    
    // MARK: - Observer Management
    
    // Removes all observers and stops the player
    func removeAllObserver() {
        stopUpdatingAmplitude()
        stopAudioStream()
        unsubscribeVolumeObserver()
        player?.removeObserver(self as! NSObject, forKeyPath: #keyPath(AVPlayer.status))
    }
    
    // MARK: - Add Radio Station to Player
    // Adds a list of stations to the player
    func addStationForPlayer(_ stations: [StationModel]) {
        self.stations = stations
    }
    
    // MARK: - Audio Playback Methods
    
    /// Plays audio from the current station's URL
    func playAudio() {
        guard let url = URL(string: currentURL) else { return }
        configureAudioSession()
        player = AVPlayer(url: url)
        player?.play()
        isPlayMusic = true
        startUpdatingAmplitude()
    }
    
    /// Pauses the currently playing audio stream
    func pauseAudioStream() {
        player?.pause()
        isPlayMusic = false
        stopUpdatingAmplitude()
    }
    
    /// Stops the audio stream and releases the player
    func stopAudioStream() {
        player = nil
        isPlayMusic = false
    }
    
    /// Plays the next station in the list
    func nextStationStream() {
        guard !stations.isEmpty else { return }
        
        indexRadio = ((indexRadio ?? -1) + 1) % stations.count
        playAudio()
    }
    
    /// Plays the previous station in the list
    func backTrackAudioStream() {
        guard !stations.isEmpty else { return }

        indexRadio = (indexRadio ?? 0) - 1
        if indexRadio! < 0 {
            indexRadio = stations.count - 1 
        }
        
        playAudio()
    }
    
    /// Plays the audio stream from the current station
    private func playAudioStream() {
        guard !stations.isEmpty else { return }
        player?.play()
        isPlayMusic = true
        startUpdatingAmplitude()
    }
    
    // MARK: - Volume
    private func configureAudioSession() {
           do {
               try session.setCategory(.playback, options: [.mixWithOthers])
               try session.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    /// Sets up the volume observer to monitor volume changes
    private func setVolumeObserver() {
        self.systemVolume = session.outputVolume
        volumeObserver = session.observe(\.outputVolume) { [weak self] session, _ in
            DispatchQueue.main.async {
                self?.systemVolume = session.outputVolume
                self?.updatePlayerVolume(self?.systemVolume ?? 1.0)
            }
        }
    }
    
    /// Removes the volume observer
    private func unsubscribeVolumeObserver() {
        volumeObserver?.invalidate()
    }
    
    func setPlayerVolume(_ volume: Float) {
        self.volume = max(0.0, min(volume, 1.0))
        player?.volume = volume
        setSystemVolume(self.volume)
    }
    
    private func setSystemVolume(_ volume: Float) {
        // Adjust the volume using MPVolumeView
        let volumeView = MPVolumeView(frame: .zero)
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            slider.value = volume
        }
    }
    
    private func updatePlayerVolume(_ volume: Float) {
        self.volume = volume
        player?.volume = volume
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
