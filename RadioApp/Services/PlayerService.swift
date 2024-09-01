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
    
    private var currentURL: String?

    var selectedStation = ""
    
    @Published var volume: CGFloat = 0.0
    @Published var amplitude: CGFloat = 0.0
    @Published var isPlayMusic = false
    
    // Audio session object
    let session = AVAudioSession.sharedInstance()
    // Observer
    var progressObserver: NSKeyValueObservation!
    
    
    // MARK: - Initialization
    init() {
        self.volume = CGFloat(session.outputVolume)
        setVolume()
    }
    
    deinit {}
    
    // MARK: - Audio Playback Methods
    func playAudio(url: String) {
        guard let url = URL.init(string: url) else { return }
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
        selectedStation = ""
    }
    
//    func nextTrackAudioStream(isPlay: Bool) {
//        var indexStation: Int?
//        for (index, station) in stations.enumerated() {
//            if selectedStation == station.stationuuid{
//                indexStation = index
//            }
//        }
//        if indexStation == nil && stations.count > 0{
//            selectedStation = stations[0].stationuuid
//            playAudio(url: stations[0].url)
//            return
//        }
//        guard var newIndex = indexStation else { return }
//        newIndex += 1
//        if isPlay && newIndex < stations.count{
//            pauseAudioStream()
//        }
//        if newIndex < stations.count {
//            selectedStation = stations[newIndex].stationuuid
//            playAudio(url: stations[newIndex].url)
//        } else {
//            return
//        }
//    }
//    
//    
//    
//    func backTrackAudioStream(isPlay: Bool) {
//        var indexStation: Int?
//        for (index, station) in stations.enumerated() {
//            if selectedStation == station.stationuuid {
//                indexStation = index
//            }
//        }
//        if indexStation == nil && stations.count > 0{
//            selectedStation = stations[stations.count-1].stationuuid
//            playAudio(url: stations[stations.count-1].url)
//            return
//        }
//        guard var newIndex = indexStation else { return }
//        newIndex -= 1
//        if isPlay && newIndex >= 0 {
//            pauseAudioStream()
//        }
//        if newIndex >= 0 {
//            selectedStation = stations[newIndex].stationuuid
//            playAudio(url: stations[newIndex].url)
//        } else {
//            return
//        }
//    }
    
    
    
    func playFirstStation(selectedStation: String) {
            playAudio(url: selectedStation)
    }
    
    //    MARK: - Volume
    func setVolume() {
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
    
    
    func unsubscribe() {
        self.progressObserver.invalidate()
    }
    
    //    MARK: -Amplitude
    func startUpdatingAmplitude() {
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                Task {  @MainActor [weak self] in
                    self?.amplitude = CGFloat.random(in: 0...1)
                }
            }
    }
    
    func stopUpdatingAmplitude() {
        timer?.cancel()
    }
}
