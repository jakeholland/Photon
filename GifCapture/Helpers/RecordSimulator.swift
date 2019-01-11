import Foundation

enum RecordSimulator {
    
    private static let path: String = "/usr/bin/xcrun"
    
    static func record(completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"

        return Process.run(path, arguments: ["simctl", "io", "booted", "recordVideo", "--mask=ignored", outputPath]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(outputPath)
            }
        }
    }
    
}
