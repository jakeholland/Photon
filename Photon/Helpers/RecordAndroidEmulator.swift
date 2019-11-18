import AppKit
import AVFoundation

enum RecordAndroidEmulator {

    private static var path: String = "~/Library/Android/sdk/platform-tools/adb"

    static func record(completion: @escaping (String) -> Void) -> Process {
        let filename = "ScreenRecording \(Date.currentDateString).mp4"
        let temporaryPath = "\(FileManager.default.temporaryDirectory.path)/\(filename)"
        let emulatorPath = "/sdcard/\(filename)".replacingOccurrences(of: " ", with: "_")

        return Process.run(path, arguments: ["shell", "screenrecord", emulatorPath], completionDelay: 0.5) { _ in
            Process.run(path, arguments: ["pull", emulatorPath, temporaryPath]) { _ in
                Process.run(path, arguments: ["shell", "rm", emulatorPath])
                completion(temporaryPath)
            }
        }
    }

    @discardableResult
    static func getRunningAndroidEmulators(completion: @escaping (Bool) -> Void) -> Process {
        Process.run(path, arguments: ["shell", "getprop", "sys.boot_completed"]) { output in
            guard let output = String(data: output, encoding: .utf8) else {
                completion(false)
                return
            }

            completion(output == "1\n")
        }
    }

}
