import Foundation

extension String {
    var filename: String { URL(fileURLWithPath: self).deletingPathExtension().relativePath }
    var gif: String { "\(filename).gif" }
    var mov: String { "\(filename).mov" }
}
