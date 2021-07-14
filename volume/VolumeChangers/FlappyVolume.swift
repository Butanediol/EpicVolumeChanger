//
//  FlappyVolume.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct FlappyVolume: View {
    
    @State var volumeValue: Float32 = getCurrentVolume() * 100
    @State var isLocked = true
    
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 20)
                    .opacity(0.5)
                Rectangle()
                    .frame(width: CGFloat(200 * volumeValue / 100), height: 20)
            }
            .cornerRadius(5)
            .clipped()
            .onReceive(timer) { _ in
                if isLocked == false {
                    if volumeValue - 0.8 > 0 {
                        withAnimation(.easeInOut) {
                            volumeValue -= 0.7
                        }
                    } else { volumeValue = 0 }
                }
                setVolume(to: Float32(volumeValue / 100))
            }
            Text("Volume: \(String(format: "%.1f", volumeValue))%")
            HStack {
                Button("Tap!") {
                    if volumeValue + 5 <= 100 {
                        volumeValue += 5
                    } else {
                        volumeValue = 100
                    }
                }
                .disabled(isLocked)
                
                Button(isLocked ? "Unlock" : " Lock") {
                    withAnimation(.spring()) {
                        isLocked.toggle()
                    }
                }
            }
        }
    }
}
