import UIKit

struct ImageModel {
    var title: String?
    var file: UploadedFiles?
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleImage
    }
    
    mutating func loadFile(_ data: UploadedFiles) {
        file = data
    }
}
