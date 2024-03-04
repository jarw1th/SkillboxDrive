import UIKit

struct WebModel {
    var title: String?
    var file: UploadedFiles?
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleWeb
    }
    
    mutating func loadFile(_ data: UploadedFiles) {
        file = data
    }
}
