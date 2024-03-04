import UIKit

struct PublicModel {
    var title: String?
    var filesList: [UploadedFiles] = []
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titlePublicScreen
    }
    
    mutating func loadFiles(_ dataList: [UploadedFiles]) {
        filesList = []
        filesList = dataList
    }
}
