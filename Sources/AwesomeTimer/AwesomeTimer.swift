//
//  AwesomeTimer.swift
//
//  Created by Arne Gockeln on 04.09.25.
//
//  https://arnesoftware.com
//

import Foundation
import Combine

/// A timer that can be used for countdowns and count-ups with millisecond precision.
@available(macOS 10.15, iOS 13, *)
final class AwesomeTimer {
    // The awesome timer supports countdown and countup mode
    enum TimerMode {
        case countdown,
             countup
    }
    
    // Holds the current mode the timer is working on
    private(set) var mode: TimerMode = .countup
    
    // callback that runs every millisecond.
    // (Elapsed Millisconds: Double)
    private(set) var onTick: ((Double) -> Void)?
    
    // current milliseconds value. will be reset every second
    private(set) var milliseconds: Double = 0
    
    // Holds the published timer
    private(set) var cancellable: AnyCancellable?
    
    // Checks wether a timer is published and running
    var isRunning: Bool {
        get {
            cancellable != nil
        }
    }
    
    // init
    init() {
        self.milliseconds = 0
    }
    
    // take a snapshot of the elapsed time without stoppping
    func snapshot() -> Double {
        return self.milliseconds
    }
    
    // start a countup with callback every millisecond
    func start(onTick: @escaping (Double) -> Void) {
        self.onTick = onTick
        self.mode = .countup
        self.milliseconds = 0
        
        self.startTimer()
    }
    
    // start a countdown with millisecond precision, duration and callback on every millisecond tick
    func startCountdown(seconds duration: Double, onTick: @escaping (Double) -> Void) {
        self.onTick = onTick
        self.mode = .countdown
        self.milliseconds = duration
        
        self.startTimer()
    }
    
    // init and publish the timer
    private func startTimer() {
        self.cancellable = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.mode == .countdown {
                    self?.milliseconds -= 0.01
                } else {
                    self?.milliseconds += 0.01
                }
                self?.processTick()
            }
    }
    
    // the timer callback called every millisecond
    private func processTick() {
        // run callback every millisecond
        if self.mode == .countup || self.mode == .countdown {
            // call the callback
            self.onTick?(self.milliseconds)
            
            // stop when the millisecond countdown is finished
            if self.mode == .countdown && self.milliseconds <= 0 {
                self.stop()
            }
            
            return
        }
    }
    
    // stops the timer
    func stop() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
    
    // pause the timer
    func pause() {
        self.stop()
    }
    
    // resume the timer
    func resume() {
        self.startTimer()
    }
}
