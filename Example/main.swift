import Foundation
import AwesomeTimer

// These examples are running all in parallel.

// This is a 3 second countdown
let awesomeTimer1 = AwesomeTimer()
awesomeTimer1.startCountdown(seconds: 3) { milliseconds in
    print("countdown ms \(milliseconds) ---")
}

// This is a 3 second countdown
let awesomeTimer2 = AwesomeTimer()
awesomeTimer2.start { milliseconds in
    print("countup ms \(milliseconds) ---")
}

RunLoop.main.run()