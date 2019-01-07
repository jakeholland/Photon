import Cocoa

extension Process {
    
    @discardableResult
    static func run(_ launchPath: String, arguments: [String], completion: (() -> Void)? = nil) -> Process {
        print("Running command: \(launchPath) \(arguments)")
        
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        process.terminationHandler = { _ in
            completion?()
        }
        process.launch()
        
        return process
    }

}
