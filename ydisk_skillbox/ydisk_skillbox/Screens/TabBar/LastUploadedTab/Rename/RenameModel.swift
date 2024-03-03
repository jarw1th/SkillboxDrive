import UIKit

struct RenameModel {
    var title: String?
    var file: UploadedFiles?
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleRename
    }
    
    mutating func loadFile(_ data: UploadedFiles) {
        file = data
    }
}
