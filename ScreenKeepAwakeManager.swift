import Foundation

final class ScreenKeepAwakeManager {
    static let shared = ScreenKeepAwakeManager()

    private let powerManager = PowerManager()

    private init() {}

    var isEnabled: Bool {
        powerManager.isPreventingDisplaySleep
    }

    func toggle() {
        setEnabled(!isEnabled)
    }

    func setEnabled(_ enabled: Bool) {
        if enabled {
            powerManager.preventDisplaySleep()
        } else {
            powerManager.allowDisplaySleep()
        }
    }
}
