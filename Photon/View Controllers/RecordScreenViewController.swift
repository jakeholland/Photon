import AppKit

final class RecordScreenViewController: NSViewController {

    @IBOutlet private var popUpButton: NSPopUpButton!

    private let windowRecordingManager = WindowRecordingManager.shared
    private let simulatorRecordingManager = SimulatorRecordingManager.shared

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
        case .simulatorId:
            simulatorRecordingManager.toggleRecording(button)
        case .mainScreenId:
            windowRecordingManager.toggleRecording(recordButton: button)
        default:
            return
        }
    }
    
    private func refreshAvailableRecordingDevices() {
        RecordSimulator.getRunningSimulators { simulatorDevices in
            var recordingOptions: [RecordingOption] = [RecordingOption(title: "Main Screen", displayId: .mainScreenId)]
            if !simulatorDevices.isEmpty {
                recordingOptions.insert(RecordingOption(title: "iOS Simulator", displayId: .simulatorId), at: 0)
            }
            
            self.recordingOptions = recordingOptions
        }
    }

}
