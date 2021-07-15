//
//  ContentView.swift
//  volume
//
//  Created by Butanediol on 14/7/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("Volume changers")) {
                    NavigationLink(
                        destination: EightBit(),
                        label: {
                            Label("8 Bit", systemImage: "checkmark.square.fill")
                        })
                    
                    NavigationLink(
                        destination: FlappyVolume(),
                        label: {
                            Label("Flappy Volume", systemImage: "gamecontroller.fill")
                        })
                    
                    NavigationLink(
                        destination: SliderTunner(),
                        label: {
                            Label("Slider", systemImage: "slider.horizontal.below.rectangle")
                        })
                    
                    NavigationLink(
                        destination: Shoot(),
                        label: {
                            Label("Shoot", systemImage: "hand.point.right.fill")
                        })
                    
                    NavigationLink(
                        destination: ColorAction(),
                        label: {
                            Label("Color Action", systemImage: "waveform.path.ecg.rectangle.fill")
                        })
                }
                
            }
            .listStyle(SidebarListStyle())
            
            Text("Epic Volume Changer")
        }
        .toolbar {
            Button(action: { toggleSidebar() }, label: {
                Label("Toggle sidebar", systemImage: "sidebar.left")
            })
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
