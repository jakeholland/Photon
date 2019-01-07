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
        videoProcess = RecordSimulator.record { filepath in
            self.menuItem?.title = "Converting..."
            let convertDate = Date()
            ConvertGif.convert(filepath) {
                print("Converting: \(abs(convertDate.timeIntervalSinceNow))")
                self.menuItem?.title = "Optimizing..."
                let optimizeDate = Date()
                OptimizeGif.optimize(filepath) {
                    self.videoProcess = nil
                    self.menuItem?.title = "Start Recording"
                    self.menuItem?.isEnabled = true
                    print("Optimizing: \(abs(optimizeDate.timeIntervalSinceNow))")
                }
            }
        }
    }
    
    func stopRecording() {
        videoProcess?.interrupt()
    }

}
