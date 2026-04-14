import Foundation
import IOKit.pwr_mgt

final class PowerManager {
    private var assertionID: IOPMAssertionID = 0

    var isPreventingDisplaySleep: Bool {
        assertionID != 0
    }

    func preventDisplaySleep() {
        guard assertionID == 0 else { return }

        let reason = "Screen Exposer is keeping the display awake" as CFString
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &assertionID
        )

        if result != kIOReturnSuccess {
            assertionID = 0
        }
    }

    func allowDisplaySleep() {
        guard assertionID != 0 else { return }

        IOPMAssertionRelease(assertionID)
        assertionID = 0
    }

    deinit {
        allowDisplaySleep()
    }
}
