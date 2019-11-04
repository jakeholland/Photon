import Cocoa

protocol DragViewDelegate {
    func dragView(didDragFileWith url: URL)
}

final class DragView: NSView {

    var delegate: DragViewDelegate?

    private let acceptedFileExtensions = ["mov", "mp4", "m4v"]
    private let types: [NSPasteboard.PasteboardType] = [NSPasteboard.PasteboardType(kUTTypeFileURL as String),
                                                        NSPasteboard.PasteboardType(kUTTypeItem as String)]
    private var isFileExtensionValid: Bool = false

    override init(frame: NSRect) {
        super.init(frame: frame)
        registerForDraggedTypes(types)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes(types)
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation  {
        isFileExtensionValid = checkExtension(sender)
        return isFileExtensionValid  ? .copy : []
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return isFileExtensionValid ? .copy : []
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedFileURL = sender.draggedFileURL else { return false }

        delegate?.dragView(didDragFileWith: draggedFileURL)

        return true
    }


    private func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension.lowercased() else { return false }

        return acceptedFileExtensions.contains(fileExtension)
    }

}

private let NSFilenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")

extension NSDraggingInfo {
    var draggedFileURL: URL? {
        guard
            let filenames = draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? [String],
            let path = filenames.first
            else { return nil }

        return URL(fileURLWithPath: path)
    }
}
