//
//  Slider.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct SliderTunner: View {
    
    @StateObject var viewModel = ViewModel()
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                
                if value.location.x > 40 {
                    viewModel.width = 40
                } else if value.location.x < 0 {
                    viewModel.width = 0
                } else {
                    viewModel.width = value.location.x
                }
                
                setVolume(to: viewModel.volumeValue)
            }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 40, height: 200)
                .opacity(0.5)
            Rectangle()
                .frame(width: viewModel.width, height: 200)
        }
        .cornerRadius(10)
        .clipped()
        .gesture(drag)
        
        Text("Volumn: \(String(format: "%.1f", viewModel.width / 0.4))%")
    }
    
    class ViewModel: ObservableObject {
        @Published var isDragging = false
        @Published var horizontalChangedValue: CGFloat = 0
        @Published var width: CGFloat = CGFloat(40 * getCurrentVolume())
        
        var volumeValue: Float32 {
            Float32(width) / 40
        }
    }
}
