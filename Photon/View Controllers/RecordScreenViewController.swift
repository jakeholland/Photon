import AppKit

final class RecordScreenViewController: NSViewController {

    @IBOutlet private var popUpButton: NSPopUpButton!
    @IBOutlet private var saveVideoChecknox: NSButton!

    private let windowRecordingManager = WindowRecordingManager.shared
    private let appleSimulatorRecordingManager = AppleSimulatorRecordingManager.shared
    private let androidEmulatorRecordingManager = AndroidEmulatorRecordingManager.shared
    private let settings = Settings()

    private var recordingOptions: [RecordingOption] = [] {
        willSet {
            guard newValue != recordingOptions else { return }
            
            DispatchQueue.main.async {
                self.popUpButton.removeAllItems()
                self.popUpButton.addItems(withTitles: self.recordingOptions.map { $0.title })
                self.popUpButton.synchronizeTitleAndSelectedItem()
            }
        }
    }
    private var recordingOptionsTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshAvailableRecordingDevices()
        saveVideoChecknox.state = settings.shouldSaveVideoFile ? .on : .off
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        recordingOptionsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.refreshAvailableRecordingDevices()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        recordingOptionsTimer?.invalidate()
    }

    @IBAction private func recordButtonPressed(_ button: NSButton) {
        let selectedOption = recordingOptions[popUpButton.indexOfSelectedItem]

        switch selectedOption.displayId {
        case .mainScreenId:
            windowRecordingManager.toggleRecording(recordButton: button)
        case .appleSimulatorId:
            appleSimulatorRecordingManager.toggleRecording(button)
        case .androidEmulatorId:
            androidEmulatorRecordingManager.toggleRecording(button)
        default:
            return
        }
    }

    @IBAction private func saveVideoPressed(_ button: NSButton) {
        let saveVideo = (button.state == .on)
        settings.shouldSaveVideoFile = saveVideo
    }
    
    private func refreshAvailableRecordingDevices() {
        var recordingOptions: [RecordingOption] = [RecordingOption(title: "Main Screen", displayId: .mainScreenId)]

        RecordAndroidEmulator.getRunningAndroidEmulators { show in
            if show {
                recordingOptions.insert(RecordingOption(title: "Android Device", displayId: .androidEmulatorId), at: 0)
            }

            RecordAppleSimulator.getRunningSimulators { simulatorDevices in
                if !simulatorDevices.isEmpty {
                    recordingOptions.insert(RecordingOption(title: "iOS Device", displayId: .appleSimulatorId), at: 0)
                }

                self.recordingOptions = recordingOptions
            }
        }
    }

}
