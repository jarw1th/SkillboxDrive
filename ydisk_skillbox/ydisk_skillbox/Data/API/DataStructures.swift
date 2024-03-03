import Foundation

struct UploadedFiles {
    let name: String
    let preview: Data?
    let created: Date
    let size: Int
    let path: String
    let publicUrl: String
    let type: String
    let id: String
    var url: URL?
}
