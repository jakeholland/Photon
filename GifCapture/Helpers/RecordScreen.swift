import AppKit
import AVFoundation

//final class RecordScreen: NSObject {
//
//    private enum Constants {
//        static let maximumSize = 1080
//        static let defaultFramerate: Double = 10
//        static var screenId: CGDirectDisplayID = CGMainDisplayID()
//    }
//
//    var isRecording: Bool { return output.isRecording }
//
//    private let output = AVCaptureMovieFileOutput()
//    private let session = AVCaptureSession()
//    private var completion: ((URL) -> Void)?
//
//    init(screenId: CGDirectDisplayID = Constants.screenId, cropRect: CGRect? = nil, framerate: Double = Constants.defaultFramerate, showCursor: Bool = false, highlightClicks: Bool = false) {
//        super.init()
//
//        guard let input = AVCaptureScreenInput(displayID: screenId) else { return }
//
//        input.minFrameDuration = CMTime(seconds: 1 / framerate, preferredTimescale: 600)
//        input.capturesCursor = showCursor
//        input.capturesMouseClicks = highlightClicks
//        if let cropRect = cropRect {
//            input.cropRect = cropRect
//        }
//
//        if session.canAddInput(input) {
//            session.addInput(input)
//        }
//
//        if session.canAddOutput(output) {
//            session.addOutput(output)
//        }
//    }
//
//    func startRecording(completion: ((URL) -> Void)? = nil) {
//        self.completion = completion
//
//        session.startRunning()
//
//        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"
//        output.startRecording(to: URL(fileURLWithPath: outputPath), recordingDelegate: self)
//    }
//
//    func stopRecording() {
//        output.stopRecording()
//        session.stopRunning()
//    }
//
//}
//
//extension RecordScreen: AVCaptureFileOutputRecordingDelegate {
//
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//        }
//        completion?(outputFileURL)
//    }
//
//}

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

        return Process.run(path, arguments: ["-v", options, outputPath]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(outputPath)
            }
        }
    }

}

