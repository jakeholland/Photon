import AppKit
import AVFoundation

enum RecordScreen {

    private static let path: String = "/usr/sbin/screencapture"

    static func record(screenId: CGDirectDisplayID?, completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"

        let options: String
        if let screenId = screenId {
            options = "-l \(screenId)"
        } else {
            options = "-m"
        }

        return Process.run(path, arguments: ["-v", options, outputPath]) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(outputPath)
            }
        }
    }

}

