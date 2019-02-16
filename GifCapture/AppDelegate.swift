import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        SimulatorRecordingManager.shared.stopRecording()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
