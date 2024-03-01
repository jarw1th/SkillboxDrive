import Foundation

struct UploadedFiles {
    let name: String
    let preview: Data
    let created: Date
    let size: Int
    let publicUrl: String?
}
