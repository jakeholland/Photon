import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        RecordingManager.shared.stopRecording()
    }
    
}
