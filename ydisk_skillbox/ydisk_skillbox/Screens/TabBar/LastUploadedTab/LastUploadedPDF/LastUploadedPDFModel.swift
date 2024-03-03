import UIKit

struct LastUploadedPDFModel {
    var title: String?
    var file: UploadedFiles?
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titlePDF
    }
    
    mutating func loadFile(_ data: UploadedFiles) {
        file = data
    }
}
