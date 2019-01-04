import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let recordingManager = RecordingManager.shared
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let recordMenuItem = NSMenuItem(title: "Record", action: #selector(toggleRecording(_:)), keyEquivalent: "")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        buildMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        recordingManager.stopRecording()
    }
    
}

extension AppDelegate {
    
    @objc private func toggleRecording(_ menuItem: NSMenuItem?) {
        recordingManager.toggleRecording(menuItem)
    }
    
    private func buildMenu() {
        guard let button = statusItem.button else { fatalError("statusItem not found") }

        button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.contentTintColor = .white
        
        let menu = NSMenu()
        menu.addItem(recordMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}
