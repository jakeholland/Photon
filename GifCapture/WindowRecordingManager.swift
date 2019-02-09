import Cocoa

final class WindowRecordingManager {

    static let shared = WindowRecordingManager()

    private var videoProcess: Process?
    private var recordButton: NSButton?
    private var isRecording: Bool { return videoProcess != nil }

    private init() { }

    func toggleRecording(screenId: CGDirectDisplayID?, recordButton: NSButton) {
        self.recordButton = recordButton

        if isRecording {
            stopRecording()
            updateButton(title: "Processing...", enabled: false)
        } else {
            startRecording(screenId: screenId)
            updateButton(title: "Stop", enabled: true)
        }
    }

    func startRecording(screenId: CGDirectDisplayID?) {
        videoProcess = RecordScreen.record(screenId: screenId) { filepath in

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
