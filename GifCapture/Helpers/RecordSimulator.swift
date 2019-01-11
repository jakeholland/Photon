import Foundation

enum RecordSimulator {
    
    private static let path: String = "/usr/bin/xcrun"
    
    private static var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
        
        return dateFormatter.string(from: Date())
    }
    
    static func record(completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(currentDateString).mov"

        return Process.run(path, arguments: ["simctl", "io", "booted", "recordVideo", "--mask=ignored", outputPath]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(outputPath)
            }
        }
    }
    
}

