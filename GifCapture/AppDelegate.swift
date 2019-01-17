import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.windows.forEach { window in
            window.isOpaque = false
            window.backgroundColor = .clear

            window.contentView?.wantsLayer = true
            window.contentView?.layer?.borderColor = NSColor.gray.cgColor
            window.contentView?.layer?.borderWidth = 2

            window.setMoving(enabled: true)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        SimulatorRecordingManager.shared.stopRecording()
    }
    
}
