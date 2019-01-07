import Cocoa

final class RecordingManager {
    
    static let shared = RecordingManager()
    
    private var videoProcess: Process?
    private var menuItem: NSMenuItem?
    private var isRecording: Bool { return videoProcess != nil }

    func toggleRecording(_ menuItem: NSMenuItem?) {
        self.menuItem = menuItem
        
        if isRecording {
            stopRecording()
            menuItem?.title = "Processing..."
            menuItem?.isEnabled = false
        } else {
            startRecording()
            menuItem?.title = "Stop Recording"
        }
    }
    
    func startRecording() {
        videoProcess = RecordSimulator.record { filename in
            ConvertGif.convert(filename) {
                self.removeVideo(filename)
                OptimizeGif.optimize(filename) {
                    self.videoProcess = nil
                    self.menuItem?.title = "Start Recording"
                    self.menuItem?.isEnabled = true
                }
            }
        }
    }
    
    func stopRecording() {
        videoProcess?.interrupt()
    }

    private func removeVideo(_ filename: String) {
        try? FileManager.default.removeItem(at: URL(fileURLWithPath: filename.mov))
    }

}
