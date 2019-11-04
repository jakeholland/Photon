import Cocoa

final class AppleSimulatorRecordingManager {
    
    static let shared = AppleSimulatorRecordingManager()
    
    private var videoProcess: Process?
    private var recordButton: NSButton?
    private var isRecording: Bool { return videoProcess != nil }

    private init() { }

    func toggleRecording(_ recordbutton: NSButton) {
        self.recordButton = recordbutton
        
        if isRecording {
            stopRecording()
            updateButton(title: "Processing...", enabled: false)
        } else {
            startRecording()
            updateButton(title: "Stop", enabled: true)
        }
    }
    
    func startRecording() {
        videoProcess = RecordAppleSimulator.record { filepath in

            self.updateButton(title: "Converting...", enabled: false)

            ConvertGif.convert(at: filepath) {

                self.updateButton(title: "Optimizing...", enabled: false)

                OptimizeGif.optimize(at: filepath, optimizationLevel: .medium) {
                    self.videoProcess = nil
                    self.updateButton(title: "Record", enabled: true)
                }
            }
        }
    }
    
    func stopRecording() {
        videoProcess?.interrupt()
    }

    private func updateButton(title: String, enabled: Bool) {
        DispatchQueue.main.async {
            self.recordButton?.title = title
            self.recordButton?.isEnabled = enabled
        }
    }

}
