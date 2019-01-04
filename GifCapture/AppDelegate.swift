import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let recordingManager = RecordingManager.shared
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let recordMenuItem = NSMenuItem(title: "Record", action: #selector(AppDelegate.toggleRecording(_:)), keyEquivalent: "r")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        buildMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
}

extension AppDelegate {
    
    @objc private func toggleRecording(_ sender: Any?) {
        recordingManager.videoProcess != nil ? recordingManager.stopRecording() : recordingManager.startRecording()
    }
    
    private func buildMenu() {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(toggleRecording(_:))
            button.contentTintColor = .white
        }
        
        let menu = NSMenu()
        
        menu.addItem(recordMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}
