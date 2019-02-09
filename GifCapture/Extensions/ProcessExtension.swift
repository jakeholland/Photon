import Cocoa

extension Process {
    
    @discardableResult
    static func run(_ launchPath: String, arguments: [String], completion: ((Data) -> Void)? = nil) -> Process {
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        
        let outpipe = Pipe()
        process.standardOutput = outpipe
        
        process.terminationHandler = { _ in
            let outputData = outpipe.fileHandleForReading.readDataToEndOfFile()
            completion?(outputData)
        }
        process.launch()
        
        return process
    }

}
