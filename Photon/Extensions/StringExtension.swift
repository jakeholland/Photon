import Foundation

extension String {
    var filename: String { return URL(fileURLWithPath: self).deletingPathExtension().relativePath }
    var gif: String { return "\(filename).gif" }
    var mov: String { return "\(filename).mov" }
}
