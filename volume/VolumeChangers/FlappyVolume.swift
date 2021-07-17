//
//  FlappyVolume.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct FlappyVolume: View {
    
    @StateObject var viewModel = ViewModel()
    
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 20)
                    .opacity(0.5)
                Rectangle()
                    .frame(width: CGFloat(200 * viewModel.volumeValue), height: 20)
            }
            .cornerRadius(5)
            .clipped()
            .onReceive(timer) { _ in
                if viewModel.isLocked == false {
                    if viewModel.volumeValue - 0.008 > 0 {
                        withAnimation(.easeInOut) {
                            viewModel.volumeValue -= 0.007
                        }
                    } else { viewModel.volumeValue = 0 }
                }
                setVolume(to: Float32(viewModel.volumeValue))
            }
            Text("Volume: \(String(format: "%.1f", viewModel.volumeValue * 100))%")
            HStack {
                Button("Tap!") {
                    if viewModel.volumeValue + 0.05 <= 1 {
                        viewModel.volumeValue += 0.05
                    } else {
                        viewModel.volumeValue = 1
                    }
                }
                .disabled(viewModel.isLocked)
                
                Button(viewModel.isLocked ? "Unlock" : " Lock") {
                    withAnimation(.spring()) {
                        viewModel.isLocked.toggle()
                    }
                }
            }
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var volumeValue: Float32 = getCurrentVolume()
        @Published var isLocked = true
    }
    
}
