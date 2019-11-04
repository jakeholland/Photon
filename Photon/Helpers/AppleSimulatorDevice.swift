struct AppleSimulatorDevices: Decodable {
    let devices: [String: [AppleSimulatorDevice]]
}

struct AppleSimulatorDevice: Decodable {
    let state: String
    let isAvailable: Bool
    let name: String
    let udid: String
    let availabilityError: String?
}
