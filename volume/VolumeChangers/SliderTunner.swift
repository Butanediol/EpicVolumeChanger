//
//  Slider.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct SliderTunner: View {
    
    @State var isDragging = false
    @State var horizontalChangedValue: CGFloat = 0
    @State var width: CGFloat = CGFloat(40 * getCurrentVolume())
    
    private var volumeValue: Float32 {
        Float32(width) / 40
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                
                if value.location.x > 40 {
                    width = 40
                } else if value.location.x < 0 {
                    width = 0
                } else {
                    width = value.location.x
                }
                
                setVolume(to: volumeValue)
            }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 40, height: 200)
                .opacity(0.5)
            Rectangle()
                .frame(width: width, height: 200)
        }
        .cornerRadius(10)
        .clipped()
        .gesture(drag)
        
        Text("Volumn: \(String(format: "%.1f", width / 0.4))%")
    }
}
