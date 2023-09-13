//
//  BubbleViewModel.swift
//  BubbleLevel
//
//  Created by Lucas Bighi on 13/09/23.
//

import Foundation
import CoreMotion
import UIKit

final class BubbleViewModel: ObservableObject {
    
    @Published var bubbleOffset: CGSize = .zero
    
    private var offset: CGSize = .zero
    private var impactOcurred: Bool = false
    
    private let motionManager: CMMotionManager
    
    init(motionManager: CMMotionManager = .init()) {
        self.motionManager = motionManager
    }
    
    @MainActor
    func listenToAccelerometerUpdates(interval: TimeInterval = 0.01) {
        motionManager.accelerometerUpdateInterval = interval
        
        if let currentOperationQueue = OperationQueue.current {
            motionManager.startAccelerometerUpdates(to: currentOperationQueue) { [weak self] data, _ in
                if let self, let data {
                    self.offset = CGSize(
                        width: (CGFloat(data.acceleration.x) * 100),
                        height: (CGFloat(data.acceleration.y) * -100)
                    )
                    
                    if absoluteOffsetValue < 2.0 {
                        self.bubbleOffset = .zero
                        sendImpactFeedback()
                    } else if absoluteOffsetValue > 1.0 {
                        self.bubbleOffset = self.offset
                        impactOcurred = false
                    }
                }
            }
        }
    }
    
    private func sendImpactFeedback() {
        if !impactOcurred {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            impactOcurred = true
        }
    }
}

// MARK: Computed properties
extension BubbleViewModel {
    private var absoluteOffsetValue: CGFloat {
        abs(self.offset.width) + abs(self.offset.height)
    }
    
    var accuracyPercent: CGFloat {
        let maxValue = 0.3
        return maxValue - maxValue * (CGFloat(absoluteOffsetValue) / 100)
    }
}
