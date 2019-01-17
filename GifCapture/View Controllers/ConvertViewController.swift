import AppKit

final class ConvertViewController: NSViewController {

    @IBOutlet private var dragView: DragView!

    override func viewDidLoad() {
        super.viewDidLoad()

        dragView.delegate = self
        dragView.wantsLayer = true
        dragView.layer?.borderColor = NSColor.gray.cgColor
        dragView.layer?.borderWidth = 2
    }

}

extension ConvertViewController: DragViewDelegate {

    func dragView(didDragFileWith url: URL) {
        ConvertGif.convert(url.relativePath) {
            OptimizeGif.optimize(url.relativePath) { }
        }
    }

}
