import UIKit

struct AllFilesModel {
    var title: String?
    var filesList: [UploadedFiles] = []
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleAllFilesScreen
    }
    
    mutating func loadFiles(_ dataList: [UploadedFiles]) {
        filesList = []
        filesList = dataList
    }
}
