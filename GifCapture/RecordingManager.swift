import Cocoa

final class RecordingManager {
    
    static let shared = RecordingManager()
    
    private var videoProcess: Process?
    private var menuItem: NSMenuItem?
    private var isRecording: Bool { return videoProcess != nil }
    
    private var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
        
        return dateFormatter.string(from: Date())
    }

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
        let fileName = "Screen Recording \(currentDateString).mov"
        
        videoProcess = run(launchPath: "/usr/bin", command: "xcrun", arguments: ["simctl", "io", "booted", "recordVideo", fileName]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.convertGif(from: fileName)
            }
        }
    }
    
    func stopRecording() {
        videoProcess?.interrupt()
    }
    
    private func convertGif(from fileName: String) {
        let gifFileName = "\(fileName.fileName ).gif"
        
        run(launchPath: "/usr/local/bin", command: "ffmpeg", arguments:  ["-i", fileName, "-f", "gif", gifFileName]) {
            self.optimizeGif(gifFileName)
        }
    }
    
    private func optimizeGif(_ fileName: String) {
        run(launchPath: "/usr/local/bin", command: "gifsicle", arguments: ["-O2", fileName, "-o", fileName]) {
            self.moveToDesktop(fileName)
        }
    }
    
    private func moveToDesktop(_ fileName: String) {
        guard let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first else { return }
        
        do {
            try FileManager.default.copyItem(atPath: fileName, toPath: "\(desktopPath)/\(fileName)")
        } catch {
            print("Error: \(error)")
        }

        videoProcess = nil
        menuItem?.title = "Start Recording"
        menuItem?.isEnabled = true
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

extension String {
    var fileName: String { return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent }
}
