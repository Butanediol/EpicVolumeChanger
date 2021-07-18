//
//  Selection.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 18/7/2021.
//

import SwiftUI

struct Selection: View {
    
    @StateObject var viewModel = ViewModel()
    
    private var columns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16, pinnedViews: []) {
                ForEach(1...100, id: \.self) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.blue)
                            .opacity(viewModel.volumeSelection[i] ? 1 : 0.15)
                        Text("\(i)%")
                            .foregroundColor(viewModel.volumeSelection[i] ? .white : .primary)
                            .lineLimit(1)
                            .padding(.horizontal, 2)
                            .padding(.vertical, 6)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.changeVolume(to: i)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 800)
    }
    
    class ViewModel: ObservableObject {
        @Published var volumeValue = getCurrentVolume()
        @Published var volumeSelection : [Bool] = {
            var arr = [Bool]()
            for i in 0...100 {
                arr.append(i + 1 == Int(round(Double(getCurrentVolume() * 100))) ? true : false)
            }
            return arr
        }()
        
        func changeVolume(to volume: Int) {
            let volumeValue = Float32(volume) / 100
            setVolume(to: volumeValue)
            volumeSelection = {
                var arr = [Bool]()
                for i in 0...100 {
                    arr.append(i == volume ? true : false)
                }
                return arr
            }()
        }
    }
}

