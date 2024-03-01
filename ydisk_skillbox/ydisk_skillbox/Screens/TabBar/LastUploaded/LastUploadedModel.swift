import UIKit

struct LastUploadedModel {
    var title: String?
    var filesList: [UploadedFiles] = []
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleLastUploadedScreen
    }
    
    mutating func loadFiles(_ dataList: [UploadedFiles]) {
        filesList = []
        filesList = dataList
    }
}
