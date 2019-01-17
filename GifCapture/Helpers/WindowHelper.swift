import Quartz

enum WindowHelper {

    struct Window {
        let id: CGDirectDisplayID
        let ownerName: String
        let name: String
        let bounds: CGRect
    }

    static func getWindows(onScreenOnly: Bool = true) -> [Window] {
        let options: CGWindowListOption
        if onScreenOnly {
            options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        } else {
            options = CGWindowListOption(arrayLiteral: .excludeDesktopElements)
        }

        let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray? as? [[String: AnyObject]] ?? []

        let windows: [Window] = windowList.compactMap { window in
            let minWindowSize: CGFloat = 50

            guard (window[kCGWindowAlpha as String]  as! Double) != 0,
                let bounds = CGRect(dictionaryRepresentation: window[kCGWindowBounds as String] as! CFDictionary),
                bounds.width > minWindowSize,
                bounds.height > minWindowSize else { return nil }

            let windowId = window[kCGWindowOwnerPID as String] as? CGDirectDisplayID ?? kCGNullWindowID
            let ownerName = window[kCGWindowOwnerName as String] as? String ?? ""
            let name = window[kCGWindowName as String] as? String ?? ""

            return Window(id: windowId, ownerName: ownerName, name: name, bounds: bounds)
        }

        return windows
    }
}
