import Foundation

enum RecordAppleSimulator {
    
    private static var path: String = "/usr/bin/xcrun"
    
    static func record(completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"

        return Process.run(path, arguments: ["simctl", "io", "booted", "recordVideo", "--mask=ignored", outputPath], completionDelay: 0.5) { _ in
            completion(outputPath)
        }
    }
    
    @discardableResult
    static func getRunningSimulators(completion: @escaping ([AppleSimulatorDevice]) -> Void) -> Process {
        return Process.run(path, arguments: ["simctl", "list", "devices", "--json"]) { output in
            guard
                let deviceList = try? JSONDecoder().decode(AppleSimulatorDevices.self, from: output)
                else {
                    completion([])
                    return
            }
            
            let bootedDevices = deviceList.devices.values.flatMap { $0 }.filter { $0.state == "Booted" }
            completion(bootedDevices)
        }
    }
    
}
