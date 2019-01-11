import AppKit

final class MainViewController: NSViewController {

    @IBOutlet private var dragView: DragView!

    private let recordingManager = RecordingManager.shared
    private let windowRecordingManager = WindowRecordingManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        dragView.delegate = self
    }

    @IBAction private func recordSimulatorButtonPressed(_ button: NSButton) {
        recordingManager.toggleRecording(button)
    }

    @IBAction private func recordScreenButtonPressed(_ button: NSButton) {
        windowRecordingManager.toggleRecording(screen: .main, recordButton: button)
    }
}

extension MainViewController: DragViewDelegate {
    func dragView(didDragFileWith url: URL) {
        ConvertGif.convert(url.relativePath) {
            OptimizeGif.optimize(url.relativePath) { }
        }
    }
}
