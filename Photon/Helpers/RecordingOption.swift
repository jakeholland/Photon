import Foundation

struct RecordingOption {
    let title: String
    let displayId: CGDirectDisplayID
}

extension RecordingOption: Equatable { }

extension CGDirectDisplayID {
    static var simulatorId: CGDirectDisplayID = 1
    static var mainScreenId: CGDirectDisplayID = 0
}
