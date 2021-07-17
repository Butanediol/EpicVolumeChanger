//
//  EightBit.swift
//  volume
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct EightBit: View{
    
    @StateObject var viewModel = ViewModel()
    
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
            Text("Volume: \(String(format: "%.1f", viewModel.volumeValue * 100))%")
                .foregroundColor(.primary)
                .padding(.horizontal)
            ForEach(0...7, id: \.self) { i in
                Toggle("\(i+1)", isOn: $viewModel.switches[i])
            }
            .onChange(of: viewModel.switches, perform: { value in
                withAnimation(.spring()) {
                    viewModel.volumeValue = 0
                    for i in 0...7 {
                        if value[i] {
                            viewModel.volumeValue += Float32(pow(2.0, Double(i))) / 255
                        }
                    }
                }
                setVolume(to: viewModel.volumeValue)
            })
        }
        .padding()
    }
    
    class ViewModel: ObservableObject {
        @Published var switches: Array<Bool> = [false, false, false, false, false, false, false, false]
        @Published var volumeValue = getCurrentVolume()
    }
}
