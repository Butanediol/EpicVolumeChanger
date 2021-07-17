//
//  Shoot.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct Shoot: View {
    
    @StateObject var viewModel = ViewModel()
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Image(systemName: "hand.point.right.fill")
                .rotationEffect(Angle(degrees: viewModel.pressTime*(-15)))
                .font(.largeTitle)
            Slider(value: $viewModel.volumeValue, in: 0...1)
                .disabled(true)
                .frame(maxWidth: 200)
        }
        .padding()
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.blue)
                .cornerRadius(10)
                .clipped()
                .opacity(0.5)
                .frame(width: CGFloat(200 * viewModel.pressTime / 3), height: 30)
                .animation(.easeInOut)
            ZStack {
                Text(viewModel.pressTime == 0 ? "Press and hold!" : "\(String(format: "%.2f", viewModel.pressTime))s")
                    .padding()
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.startTime == nil ? Color.blue : Color.secondary, lineWidth: 2)
                    .frame(width: 200, height: 30)
            }
        }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if viewModel.startTime == nil {
                            viewModel.startTime = Date()
                        }
                    }
                    .onEnded { _ in
                        let timeInterval: TimeInterval = viewModel.startTime!.distance(to: Date())
                        viewModel.startTime = nil
                        viewModel.pressTime = 0
                        viewModel.volumeValue = Float32(timeInterval <= 3 ? timeInterval : 3) / 3
                        setVolume(to: viewModel.volumeValue)
                    }
            )
            .onReceive(timer) { _ in
                if viewModel.startTime != nil {
                    viewModel.pressTime = viewModel.pressTime + 0.05 <= 3 ? viewModel.pressTime + 0.05 : 3
                }
            }
    }
    
    class ViewModel: ObservableObject {
        @Published var startTime: Date?
        @Published var volumeValue: Float32 = getCurrentVolume()
        @Published var pressTimeInterval: Double?
        @Published var pressTime: Double = 0
    }
    
}
