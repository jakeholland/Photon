import Foundation

struct RecordingOption {
    let title: String
    let displayId: CGDirectDisplayID
}

extension RecordingOption: Equatable { }

extension CGDirectDisplayID {
    static var mainScreenId: CGDirectDisplayID = 0
    static var appleSimulatorId: CGDirectDisplayID = 1
    static var androidEmulatorId: CGDirectDisplayID = 2
}
