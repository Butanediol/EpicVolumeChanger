//
//  ColorAction.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 15/7/2021.
//

import SwiftUI
import Combine

struct ColorAction: View {
    @State var volumeValue = getCurrentVolume()
    @State var offset: Int = 0
    @State var rightDirection = true
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            VStack {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: 40, height: 200)
                        .opacity(0.5)
                    Rectangle()
                        .frame(width: 40, height: CGFloat(200 * volumeValue))
                }
                .cornerRadius(10)
                .clipped()
                
                Text("Volume: \(String(format: "%.0f", volumeValue * 100))%")
                
                ZStack {
                    Group {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 200)
                        Rectangle()
                            .foregroundColor(.green)
                            .frame(width: 200 * 0.05)
                    }
                    .frame(height: 20)
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 200 * 0.01, height: 30)
                        .offset(x: CGFloat(offset), y: 0)
                }
                
                Button("Press") {
                    withAnimation(.spring()) {
                        if (offset >= -6) && (offset <= 6) {
                            volumeValue += 0.05
                            setVolume(to: volumeValue)
                        } else {
                            volumeValue = 0
                            setVolume(to: volumeValue)
                        }
                    }
                }
            }
            .onReceive(timer) { _ in
                if (offset == 100) || (offset == -100) {
                    rightDirection.toggle()
                }
                offset += rightDirection ? 1 : -1
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                    Text("Volume set to zero.")
                }
                
                HStack {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                    Text("Volume increases by 5%.")
                }
            }
        }
    }
}
