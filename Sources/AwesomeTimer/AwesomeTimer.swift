//
//  AwesomeTimer.swift
//
//  Created by Arne Gockeln on 04.09.25.
//
//  https://arnesoftware.com
//

import Foundation
import Combine

/// A timer that can be used for second countdowns and count-ups, as well as millisecond count-ups.
@available(macOS 10.15, iOS 13, *)
final class AwesomeTimer {
    // The awesome timer supports countdown and countup mode
    enum TimerMode {
        case countdown, countup, countupMillisecond
    }
    
    // Holds the current mode the timer is working on
    private(set) var mode: TimerMode = .countdown
    
    // callback that runs every second. In countdown mode the Int parameter representes the remaining seconds. In countup mode the elapsed seconds
    // (Seconds:Int)
    private(set) var onSecond: ((Int) -> Void)?
    
    // callback that runs every millisecond. Only in countupMillisecond mode!
    // (Elapsed Millisconds: Double)
    private(set) var onMillisecond: ((Double) -> Void)?
    
    // current milliseconds value. will be reset every second
    private(set) var milliseconds: Double = 0
    
    // In countdown mode the starting value to countdown, in countup mode the elapsed seconds
    private(set) var durationSeconds: Int = 0
    
    // Holds the published timer
    private(set) var cancellable: AnyCancellable?
    
    // Checks wether a timer is published and running
    var isRunning: Bool {
        get {
            cancellable != nil
        }
    }
    
    init() {
        self.durationSeconds = 0
        self.milliseconds = 0
    }
    
    // start a countup with callback every second
    func start(onSecond: @escaping (Int) -> Void) {
        self.durationSeconds = 0
        self.onSecond = onSecond
        self.mode = .countup
        
        self.startTimer()
    }
    
    // start a countup with callback every millisecond
    func startMillisecond(onMillisecond: @escaping (Double) -> Void) {
        self.durationSeconds = 0
        self.onMillisecond = onMillisecond
        self.mode = .countupMillisecond
        
        self.startTimer()
    }
    
    // start a countdown with a duration and callback every second
    func startCountdown(seconds duration: Int, onSecond: @escaping(Int) -> Void) {
        self.durationSeconds = duration
        self.onSecond = onSecond
        self.mode = .countdown
        
        self.startTimer()
    }
    
    // init and publish the timer
    private func startTimer() {
        self.milliseconds = 0
            
        self.cancellable = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.milliseconds += 0.01
                self?.onTick()
            }
    }
    
    // the timer callback called every millisecond
    private func onTick() {
        // run callback every millisecond
        self.onMillisecond?(self.milliseconds)
        
        // is a second ago
        guard self.mode != .countupMillisecond, self.milliseconds >= 1.0 else { return }
        
        // reset ms counter
        self.milliseconds = 0
        
        switch self.mode {
            case .countdown:
                // decrease duration
                self.durationSeconds -= 1
                if self.durationSeconds <= 0 {
                    self.stop()
                }
            
                // countup
            default:
                // increase duration
                self.durationSeconds += 1
        }
        
        // call the callback
        self.onSecond?(self.durationSeconds)
    }
    
    // stops the timer
    func stop() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}
