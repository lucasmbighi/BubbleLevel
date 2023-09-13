//
//  ContentView.swift
//  BubbleLevel
//
//  Created by Lucas Bighi on 13/09/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel: BubbleViewModel
    
    init(viewModel: BubbleViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Circle()
                .stroke(.white, lineWidth: 5)
                .overlay(
                    Circle()
                        .fill(bubbleColor)
                        .offset(viewModel.bubbleOffset)
                        .animation(.easeInOut, value: viewModel.bubbleOffset)
                )
                .padding(60)
        }
        .onAppear {
            viewModel.listenToAccelerometerUpdates()
        }
    }
    
    private var bubbleColor: Color {
        Color(hue: viewModel.accuracyPercent, saturation: 1, brightness: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
