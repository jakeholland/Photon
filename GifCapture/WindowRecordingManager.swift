import AppKit

final class WindowRecordingManager {

    var runningApps: [NSRunningApplication] { return NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular } }
    var windowList: [[String: AnyObject]] { return CGWindowListCopyWindowInfo(.optionIncludingWindow, CGWindowID(0)) as NSArray? as? [[String: AnyObject]] ?? [] }
    var screens: [NSScreen] { return NSScreen.screens }

    private var recordButton: NSButton?
    private var recordScreen: RecordScreen?
    private var isRecording: Bool { return recordScreen != nil }

    func toggleRecording(screen: NSScreen?, recordButton: NSButton) {
        self.recordButton = recordButton

        if isRecording {
            stopRecording()
            updateButton(title: "Processing...", enabled: false)
        } else if let screen = screen{
            startRecording(screen)
            updateButton(title: "Stop Recording", enabled: true)
        }
    }

    func startRecording(_ screen: NSScreen) {
        recordScreen = RecordScreen(screenId: screen.screenId)

        recordScreen?.startRecording { outputFileURL in

            self.updateButton(title: "Converting...", enabled: false)

            ConvertGif.convert(outputFileURL.relativePath) {

                self.updateButton(title: "Optimizing...", enabled: false)
                
                OptimizeGif.optimize(outputFileURL.relativePath) {
                    self.updateButton(title: "Record Screen", enabled: true)
                    self.recordScreen = nil
                }
            }
        }
    }

    func stopRecording() {
        recordScreen?.stopRecording()
    }

    private func updateButton(title: String, enabled: Bool) {
        DispatchQueue.main.async {
            self.recordButton?.title = title
            self.recordButton?.isEnabled = enabled
        }
    }

}
