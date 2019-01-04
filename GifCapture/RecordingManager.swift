import Cocoa

final class RecordingManager {
    
    static let shared = RecordingManager()
    
    private(set) var videoProcess: Process?
    
    private var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
        
        return dateFormatter.string(from: Date())
    }
    
    func startRecording() {
        stopRecording()
        
        self.videoProcess = run(launchPath: "/usr/bin", command: "xcrun", arguments: ["simctl", "io", "booted", "recordVideo", "recording.mov"]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.convertGif(from: "recording.mov")
            }
        }
    }
    
    func stopRecording() {
        videoProcess?.interrupt()
    }
    
    private func convertGif(from fileName: String) {
        let finalFileName = "Screen Recording \(currentDateString)"
        
        run(launchPath: "/usr/local/bin", command: "ffmpeg", arguments:  ["-i", fileName, "-f", "gif", finalFileName]) {
            self.optimizeGif(finalFileName)
        }
    }
    
    private func optimizeGif(_ fileName: String) {
        run(launchPath: "/usr/local/bin", command: "gifsicle", arguments: ["-O3", fileName, "-o", fileName]) {
            self.moveToDesktop(fileName)
        }
    }
    
    private func moveToDesktop(_ fileName: String) {
        run(launchPath: "/bin", command: "mv", arguments: [fileName, "~/Desktop"])
    }
    
    @discardableResult
    private func run(launchPath: String, command: String, arguments: [String], completionHandler: (() -> Void)? = nil) -> Process {
        print("Running command: \(command)")
        let process = Process()
    
        process.launchPath = "\(launchPath)/\(command)"
        process.arguments = arguments
        process.terminationHandler = { _ in
            completionHandler?()
        }
        process.launch()
        
        return process
    }

}
