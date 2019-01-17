import Cocoa

extension NSWindow {
    func setMoving(enabled: Bool) {
        if enabled {
            styleMask.update(with: .resizable)
            isMovable = true
            isMovableByWindowBackground = true
            level = .normal
        } else {
            styleMask.remove(.resizable)
            isMovable = false
            level = .floating
        }
    }
}
