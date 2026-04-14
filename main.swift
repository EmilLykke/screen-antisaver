import AppKit
import Foundation

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let awakeManager = ScreenKeepAwakeManager.shared
    private var statusItem: NSStatusItem!
    private var toggleItem: NSMenuItem!
    private let logURL = URL(fileURLWithPath: "/tmp/screen-exposer.log")

    func applicationDidFinishLaunching(_ notification: Notification) {
        log("applicationDidFinishLaunching")

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        log("statusItem created: \(statusItem != nil)")

        guard let button = statusItem.button else {
            log("statusItem.button was nil")
            return
        }

        log("statusItem.button available")

        let menu = NSMenu()

        toggleItem = NSMenuItem(
            title: "Keep Screen Awake",
            action: #selector(toggleKeepAwake),
            keyEquivalent: ""
        )
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit Screen Exposer",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = NSApp
        menu.addItem(quitItem)

        statusItem.menu = menu
        refreshUI()
        log("refreshUI completed")
    }

    func applicationWillTerminate(_ notification: Notification) {
        log("applicationWillTerminate")
    }

    @objc private func toggleKeepAwake() {
        awakeManager.toggle()
        refreshUI()
    }

    private func refreshUI() {
        toggleItem.state = awakeManager.isEnabled ? .on : .off
        updateIcon()
    }

    private func updateIcon() {
        guard let button = statusItem.button else { return }

        let symbolName = awakeManager.isEnabled ? "sun.max.fill" : "moon.zzz.fill"
        let configuration = NSImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Screen Exposer")?
            .withSymbolConfiguration(configuration)

        image?.isTemplate = true

        button.title = awakeManager.isEnabled ? "SE On" : "SE Off"
        button.image = image
        button.imagePosition = .imageLeading
        button.contentTintColor = nil
        button.toolTip = awakeManager.isEnabled ? "Screen Exposer: On" : "Screen Exposer: Off"
        log("button updated with title: \(button.title)")
    }

    private func log(_ message: String) {
        let line = "\(Date()): \(message)\n"
        if let data = line.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logURL.path) {
                if let handle = try? FileHandle(forWritingTo: logURL) {
                    try? handle.seekToEnd()
                    try? handle.write(contentsOf: data)
                    try? handle.close()
                }
            } else {
                try? data.write(to: logURL)
            }
        }
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
