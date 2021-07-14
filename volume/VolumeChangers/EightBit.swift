//
//  EightBit.swift
//  volume
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct EightBit: View{
    
    @State var switches: Array<Bool> = [false, false, false, false, false, false, false, false]
    @State var volumeValue = getCurrentVolume()
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 20)
                    .opacity(0.5)
                Rectangle()
                    .frame(width: CGFloat(200 * volumeValue), height: 20)
            }
            .cornerRadius(5)
            .clipped()
            Text("Volume: \(String(format: "%.1f", volumeValue * 100))%")
                .foregroundColor(.primary)
                .padding(.horizontal)
            ForEach(0...7, id: \.self) { i in
                Toggle("\(i+1)", isOn: $switches[i])
            }
            .onChange(of: switches, perform: { value in
                withAnimation(.spring()) {
                    volumeValue = 0
                    for i in 0...7 {
                        if value[i] {
                            volumeValue += Float32(pow(2.0, Double(i))) / 255
                        }
                    }
                }
                setVolume(to: volumeValue)
            })
        }
        .padding()
    }
}
