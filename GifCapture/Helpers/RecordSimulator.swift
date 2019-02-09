import Foundation

enum RecordSimulator {
    
    private static var path: String {
        guard let path = Bundle.main.path(forResource: "xcrun", ofType: nil) else { fatalError("xcrun not found") }
        
        return path
    }
    
    static func record(completion: @escaping (String) -> Void) -> Process {
        let outputPath = "\(FileManager.default.temporaryDirectory.path)/ScreenRecording \(Date.currentDateString).mov"

        return Process.run(path, arguments: ["simctl", "io", "booted", "recordVideo", "--mask=ignored", outputPath]) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(outputPath)
            }
        }
    }
    
    @discardableResult
    static func getRunningSimulators(completion: @escaping ([SimulatorDevice]) -> Void) -> Process {
        return Process.run(path, arguments: ["simctl", "list", "devices", "--json"]) { output in
            guard
                let deviceList = try? JSONDecoder().decode(SimulatorDevices.self, from: output)
                else {
                    completion([])
                    return
            }
            
            let bootedDevices = deviceList.devices.values.flatMap { $0 }.filter { $0.state == "Booted" }
            completion(bootedDevices)
        }
    }
    
}
