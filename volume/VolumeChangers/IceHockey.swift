//
//  IceHockey.swift
//  Epic Volume Changer
//
//  Created by Butanediol on 19/7/2021.
//

import SwiftUI
import UserNotifications

struct IceHockey: View {
    
    @StateObject var viewModel = ViewModel()
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: viewModel.expanded ? 400 : 200, height: viewModel.expanded ? 300 : 10)
                    .gesture(DragGesture().onChanged { viewModel.stickDragged(value: $0) })
                Rectangle()
                    .frame(width: viewModel.expanded ? 10 : 2, height: viewModel.expanded ? 300 : 20)
                    .offset(x: viewModel.lineOffset)
                    .foregroundColor(.blue)
                Text("🏒️")
                    .font(.system(size: 100))
                    .opacity(viewModel.expanded ? 1 : 0)
                    .position(viewModel.stickPosition)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: viewModel.expanded ? 30 : 20, height: viewModel.expanded ? 30 : 20)
                    .offset(x: viewModel.ballOffset, y: 0)
                    .shadow(radius: 10)
                    .gesture(DragGesture().onChanged { viewModel.ballDragged(value: $0) })
            }
            .rotation3DEffect(
                viewModel.expanded ? .degrees(45) : .zero,
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .onReceive(timer) { _ in
                viewModel.timerAction()
            }
            
            Text("Volume \(String(format: "%.1f", Double(viewModel.moves >= 500 ? 500 : viewModel.moves) / 5))%")
        }
        .padding()
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if success {
                    viewModel.canPushNotification = true
                }
            }
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var ballOffset: CGFloat = -30
        @Published var lineOffset: CGFloat = 0
        @Published var expanded: Bool = false
        @Published var velocity: Double = 1
        @Published var stickPosition: CGPoint = .zero
        @Published var moves = 0
        
        var canPushNotification = false
        
        func enableGameMode() {
            withAnimation(.easeInOut(duration: 1)) {
                self.expanded = true
                self.ballOffset = -100
                self.lineOffset = -195
            }
        }
        
        func disableGameMode() {
            let volumeValue = Float32(moves >= 500 ? 500 : moves) / 500
            setVolume(to: volumeValue)
            pushNotification(volumeValue)
            withAnimation(.easeInOut(duration: 1)) {
                expanded = false
                lineOffset = 0
                ballOffset = -30
            }
            velocity = 1
            moves = 0
        }
        
        func pushNotification(_ volume: Float32) {
            guard canPushNotification else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "Well done!"
            content.subtitle = "Volume set to \(String(format: "%.1f", volume * 100))%"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
        
        func stickDragged(value: DragGesture.Value) {
            if expanded {
                stickPosition.x = value.location.x + 100
                stickPosition.y = value.location.y + 100
                moves += 1
                velocity += 0.001
            }
        }
        
        func ballDragged(value: DragGesture.Value) {
            if expanded == false {
                ballOffset = value.location.x - 10
            }
            if value.predictedEndLocation.x >= 200 && value.location.x >= 100 {
                enableGameMode()
            }
        }
        
        func timerAction() {
            if expanded {
                if lineOffset == -195 {
                    lineOffset = 195
                }
                if lineOffset == 195 {
                    withAnimation(.linear(duration: 1)) {
                        lineOffset = -195
                    }
                }
                
                velocity -= 0.3
                if velocity <= 0 {
                    disableGameMode()
                }
            }
        }
    }
}
