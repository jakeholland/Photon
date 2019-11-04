import Cocoa

extension Process {
    
    @discardableResult
    static func run(_ launchPath: String, arguments: [String], completionDelay: TimeInterval = 0, completion: ((Data) -> Void)? = nil) -> Process {
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        
        let outpipe = Pipe()
        process.standardOutput = outpipe
        
        process.terminationHandler = { _ in
            guard let completion = completion else { return }

            let outputData = outpipe.fileHandleForReading.readDataToEndOfFile()

            DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
                completion(outputData)
            }
        }
        process.launch()
        
        return process
    }

}
