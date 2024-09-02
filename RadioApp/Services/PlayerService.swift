//
//  PlayerService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

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
    let session = AVAudioSession.sharedInstance()
    // Observer
    var progressObserver: NSKeyValueObservation!
    
    @Published var stations = [StationModel]()
    @Published var indexRadio = 0
    
    @Published var volume: CGFloat = 0.0
    @Published var amplitude: CGFloat = 0.0
    @Published var isPlayMusic = false
    
    var currentStation: StationModel {
        get { stations[indexRadio] }
        set {
            self.indexRadio = stations.firstIndex(of: newValue) ?? 0
        }
    }
    
    private var currentURL: String {
        currentStation.url
    }
    
    // MARK: - Initialization
    init() {
        self.volume = CGFloat(session.outputVolume)
        setVolume()
    }
    
    func `deinit`() {
        stopUpdatingAmplitude()
        stopAudioStream()
        unsubscribe()
        player?.removeObserver(self as! NSObject, forKeyPath: #keyPath(AVPlayer.status))
    }
    
    // MARK: - Add RadioStation in Player
    func addStationForPlayer(_ stations: [StationModel]) {
        self.stations.append(contentsOf: stations)
        indexRadio = min(indexRadio, stations.count - 1)
    }
    
    // MARK: - Audio Playback Methods
    func playAudio() {
        guard let url = URL.init(string: currentURL) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            player = AVPlayer(url: url)
            playAudioStream()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func playAudioStream() {
        if player != nil {
            player?.play()
            isPlayMusic = true
            startUpdatingAmplitude()
        }
    }
    
    func pauseAudioStream() {
        if player != nil {
            player?.pause()
            isPlayMusic = false
            stopUpdatingAmplitude()
        }
    }
    
    func stopAudioStream() {
        isPlayMusic = false
        player = nil
    }
    
    func nextStationStream() {
        indexRadio = (indexRadio + 1) % stations.count
        currentStation = stations[indexRadio]
        playAudio()
    }
    
    func backTrackAudioStream() {
        indexRadio = (indexRadio - 1 + stations.count) % stations.count
        currentStation = stations[indexRadio]
        playAudio()
    }
    
    
    //    MARK: - Volume
    private func setVolume() {
        do {
            try session.setCategory(AVAudioSession.Category.ambient)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err {
            print(err.localizedDescription)
        }
        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = CGFloat(session.outputVolume)
                print("current volume value - \(self.volume)")
            }
        }
    }
    
    
    private func unsubscribe() {
        self.progressObserver.invalidate()
    }
    
    //    MARK: -Amplitude
    private func startUpdatingAmplitude() {
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                Task {  @MainActor [weak self] in
                    self?.amplitude = CGFloat.random(in: 0...1)
                }
            }
    }
    
    private func stopUpdatingAmplitude() {
        timer?.cancel()
    }
}
