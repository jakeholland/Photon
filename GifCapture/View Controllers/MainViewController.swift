import AppKit

final class MainViewController: NSViewController {

    @IBOutlet private var dragView: DragView!

    private let recordingManager = RecordingManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        dragView.delegate = self
    }

    @IBAction private func recordButtonPressed(_ button: NSButton) {
        recordingManager.toggleRecording(button)
    }
}

extension MainViewController: DragViewDelegate {
    func dragView(didDragFileWith url: URL) {
        ConvertGif.convert(url.relativePath) { }
    }
}
