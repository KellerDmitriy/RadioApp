//
//  VolumeSliderView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI

// MARK: - View
struct VolumeSliderView: View {
    @Binding var volume: Float
    @State private var lastCoordinateValue: CGFloat = 0.0
    @State var horizontal: Bool = false
    @State var mute: Bool = false
    @EnvironmentObject var playerService: PlayerService

    private let minValue: Double = 0.0
    private let maxValue: Double = 190.0

    var body: some View {
        GeometryReader { geometry in
            let sliderLength: CGFloat = maxValue
            let sliderThickness: CGFloat = 2
            let knobSize: CGFloat = 15

            VStack {
                if horizontal {
                    HStack {
                        volumeIcon()
                        slider(sliderLength: sliderLength, sliderThickness: sliderThickness, knobSize: knobSize)
                        volumeTextLabel()
                    }
                } else {
                    VStack {
                        volumeTextLabel()
                        slider(sliderLength: sliderLength, sliderThickness: sliderThickness, knobSize: knobSize)
                        volumeIcon()
                    }
                }
            }
        }
        .onAppear {
            lastCoordinateValue = CGFloat(Double(volume) * maxValue)
        }
        .onChange(of: playerService.volume) { newValue in
            self.volume = newValue  
        }
        .animation(.linear(duration: 0.1), value: volume)
    }

    // MARK: - Мьютинг звука
    private func toggleMute() {
        if volume != 0.0 {
            playerService.setPlayerVolume(0.0)
            mute = true
        } else {
            playerService.setPlayerVolume(Float(lastCoordinateValue / maxValue))
            mute = false
        }
    }

    // MARK: - Иконка громкости
    private func volumeIcon() -> some View {
        Image(systemName: volumeIconName(volume: volume))
            .foregroundColor(.gray)
            .frame(width: 20, height: 20)
            .onTapGesture {
                toggleMute()
            }
            .padding(horizontal ? .trailing : .top, 10)
    }

    // MARK: - Текстовое отображение громкости
    private func volumeTextLabel() -> some View {
        Text(volumeText(volume: Double(volume) * maxValue))
            .foregroundColor(.white)
            .font(.custom(.sfRegular, size: 18))
            .frame(width: 60)
            .padding(horizontal ? .leading : .bottom, 10)
    }

    // MARK: - Общий слайдер для обоих направлений
    private func slider(sliderLength: CGFloat, sliderThickness: CGFloat, knobSize: CGFloat) -> some View {
        ZStack(alignment: horizontal ? .leading : .bottom) {
            // Фон слайдера
            RoundedRectangle(cornerRadius: 10)
                .frame(width: horizontal ? sliderLength : sliderThickness, height: horizontal ? sliderThickness : sliderLength)
                .foregroundColor(Color.gray.opacity(0.2))

            // Заполненная часть
            RoundedRectangle(cornerRadius: 10)
                .frame(width: horizontal ? CGFloat(Double(volume) * maxValue) : sliderThickness,
                       height: horizontal ? sliderThickness : CGFloat(Double(volume) * maxValue))
                .foregroundColor(DS.Colors.blueNeon)

            // Ползунок
            Circle()
                .foregroundColor(DS.Colors.blueNeon)
                .frame(width: knobSize, height: knobSize)
                .offset(
                    x: horizontal ? CGFloat(Double(volume) * maxValue - knobSize).clamped(to: 0...maxValue) : 0,
                    y: horizontal ? 0 : -CGFloat(Double(volume) * maxValue).clamped(to: 0...maxValue)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { v in
                            let newValue = horizontal
                                ? (lastCoordinateValue + v.translation.width).clamped(to: minValue...maxValue)
                                : (lastCoordinateValue - v.translation.height).clamped(to: minValue...maxValue)
                            playerService.setPlayerVolume(Float(newValue / maxValue))
                        }
                        .onEnded { _ in
                            lastCoordinateValue = CGFloat(Double(volume) * maxValue)
                        }
                )
        }
        .frame(width: horizontal ? sliderLength : sliderThickness,
               height: horizontal ? sliderThickness : sliderLength)
    }

    private func volumeIconName(volume: Float) -> String {
        switch volume {
        case 0:
            return "volume.slash.fill"
        case 0..<0.333:
            return "volume.1.fill"
        case 0.333..<0.667:
            return "volume.2.fill"
        case 0.667...1:
            return "volume.3.fill"
        default:
            return "volume.fill"
        }
    }

    private func volumeText(volume: Double) -> String {
        "\(Int(volume / maxValue * 100))%"
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

//MARK: - Пример Preview
#Preview {
    VolumeSliderView(volume: .constant(0.5), horizontal: false)
        .environmentObject(PlayerService.shared)
}
