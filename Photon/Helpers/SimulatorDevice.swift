struct SimulatorDevices: Decodable {
    let devices: [String: [SimulatorDevice]]
}

struct SimulatorDevice: Decodable {
    let availability: String
    let state: String
    let isAvailable: Bool
    let name: String
    let udid: String
    let availabilityError: String
}