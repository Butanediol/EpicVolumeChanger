//
//  ColorAction.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 15/7/2021.
//

import SwiftUI
import Combine

struct ColorAction: View {
    
    @StateObject var viewModel = ViewModel()
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            VStack {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: 40, height: 200)
                        .opacity(0.5)
                    Rectangle()
                        .frame(width: 40, height: CGFloat(200 * viewModel.volumeValue))
                }
                .cornerRadius(10)
                .clipped()
                
                Text("Volume: \(String(format: "%.0f", viewModel.volumeValue * 100))%")
                
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
                        .offset(x: CGFloat(viewModel.offset), y: 0)
                }
                
                Button("Press") {
                    withAnimation(.spring()) {
                        if (viewModel.offset >= -6) && (viewModel.offset <= 6) {
                            viewModel.volumeValue += 0.05
                            setVolume(to: viewModel.volumeValue)
                        } else {
                            viewModel.volumeValue = 0
                            setVolume(to: viewModel.volumeValue)
                        }
                    }
                }
            }
            .onReceive(timer) { _ in
                if (viewModel.offset == 100) || (viewModel.offset == -100) {
                    viewModel.rightDirection.toggle()
                }
                viewModel.offset += viewModel.rightDirection ? 1 : -1
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
    
    class ViewModel: ObservableObject {
        @Published var volumeValue = getCurrentVolume()
        @Published var offset: Int = 0
        @Published var rightDirection = true
    }
    
}
