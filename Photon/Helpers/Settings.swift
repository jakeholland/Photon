import Foundation

final class Settings {

    private enum Keys: String {
        case saveVideo
    }

    var shouldSaveVideoFile: Bool {
        get { userDefaults.bool(forKey: Keys.saveVideo.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.saveVideo.rawValue) }
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

}
