import Foundation
import AwesomeTimer

// These examples are running all in parallel.

// This is a 3 second countdown
let awesomeTimer1 = AwesomeTimer()
awesomeTimer1.startCountdown(seconds: 3) { remainingSeconds in
    print("countdown second \(remainingSeconds) ---")
}

// This is a 10 second countup
let awesomeTimer2 = AwesomeTimer()
awesomeTimer2.start { seconds in
    print("elapsed \(seconds)")

    if seconds >= 10 {
        awesomeTimer2.stop()
    }
}

// This is a 5 second countup with millisecond callback
let awesomeTimer3 = AwesomeTimer()
awesomeTimer3.startMillisecond { ms in
    print("elapsed ms \(ms)")
    
    if ms > 5 {
        awesomeTimer3.stop()
    }
}

RunLoop.main.run()