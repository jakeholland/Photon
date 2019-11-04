import AppKit
import AVFoundation

enum RecordScreen {

    private static var path: String {
        guard let path = Bundle.main.path(forResource: "ffmpeg", ofType: nil) else { fatalError("ffmpeg not found") }
        
        return path
    }

    static func record(completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"

        return Process.run(path, arguments: ["-f", "avfoundation", "-i", "1", "-pix_fmt", "yuv420p", "-r", "25", outputPath], completionDelay: 0.5) { _ in
            completion(outputPath)
        }
    }

}

