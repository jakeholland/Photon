import Foundation

extension Date {
    static var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"

        return dateFormatter.string(from: Date())
    }
}
