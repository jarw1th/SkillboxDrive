import Foundation

// MARK: Files Struct
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

// MARK: Disk information Struct
struct DiskInfo {
    let usedSpace: Int
    let totalSpace: Int
}
