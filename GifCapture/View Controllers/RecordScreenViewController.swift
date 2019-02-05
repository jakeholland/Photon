import AppKit

final class RecordScreenViewController: NSViewController {

    private let simulatorId: CGDirectDisplayID = 1
    private let mainScreenId: CGDirectDisplayID = 0

    @IBOutlet private var popUpButton: NSPopUpButton!

    private let windowRecordingManager = WindowRecordingManager.shared
    private let simulatorRecordingManager = SimulatorRecordingManager.shared

    private var windows: [WindowHelper.Window] { return WindowHelper.getWindows() }
    private var recordingOptions: [(String, CGDirectDisplayID)] {
        let options = [("Main Screen", mainScreenId), ("iOS Simulator", simulatorId)]
//        options.append(contentsOf: windows.map { ("\($0.ownerName) - \($0.name)", $0.id) })

        return options
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpButton.addItems(withTitles: recordingOptions.map { $0.0 })
    }

    @IBAction private func recordButtonPressed(_ button: NSButton) {
        let selectedOption = recordingOptions[popUpButton.indexOfSelectedItem]

        switch selectedOption.1 {
        case simulatorId:
            simulatorRecordingManager.toggleRecording(button)
        case mainScreenId:
            windowRecordingManager.toggleRecording(screenId: NSScreen.main?.screenId, recordButton: button)
        default:
            windowRecordingManager.toggleRecording(screenId: selectedOption.1, recordButton: button)
        }
    }

}
