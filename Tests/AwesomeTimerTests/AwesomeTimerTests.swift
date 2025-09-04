import Testing
@testable import AwesomeTimer

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func testSecondCountdown() async throws {
    let timer = AwesomeTimer()
    var count = 4
    timer.startCountdown(seconds: 4) { _ in 
        count -= 1
    }

    // does not work. 
    #expect(count == 0)
}