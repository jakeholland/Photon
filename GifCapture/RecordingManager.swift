import Cocoa

final class RecordingManager {
    
    static let shared = RecordingManager()
    
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
            updateButton(title: "Stop Recording", enabled: true)
        }
    }
    
    func startRecording() {
        videoProcess = RecordSimulator.record { filepath in

            self.updateButton(title: "Converting...", enabled: false)

            ConvertGif.convert(filepath) {

                self.updateButton(title: "Optimizing...", enabled: false)

                OptimizeGif.optimize(filepath) {
                    self.videoProcess = nil
                    self.updateButton(title: "Record Simulator", enabled: true)
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
