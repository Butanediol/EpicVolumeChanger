//
//  Shoot.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct Shoot: View {
    @State var startTime: Date?
    @State var volumeValue: Float32 = getCurrentVolume()
    @State var pressTimeInterval: Double?
    @State var pressTime: Double = 0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Image(systemName: "hand.point.right.fill")
                .rotationEffect(Angle(degrees: pressTime*(-15)))
                .font(.largeTitle)
            Slider(value: $volumeValue, in: 0...1)
                .disabled(true)
                .frame(maxWidth: 200)
        }
        .padding()
        ZStack {
            Text(pressTime == 0 ? "Press and hold!" : "\(String(format: "%.2f", pressTime))s")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(startTime == nil ? Color.blue : Color.secondary, lineWidth: 2)
                        .frame(width: 200, height: 40)
                )
        }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if startTime == nil {
                            startTime = Date()
                        }
                    }
                    .onEnded { _ in
                        let timeInterval: TimeInterval = startTime!.distance(to: Date())
                        startTime = nil
                        pressTime = 0
                        volumeValue = Float32(timeInterval <= 3 ? timeInterval : 3) / 3
                        setVolume(to: volumeValue)
                    }
            )
            .onReceive(timer) { _ in
                if startTime != nil {
                    pressTime = pressTime + 0.05 <= 3 ? pressTime + 0.05 : 3
                }
            }
    }
}
