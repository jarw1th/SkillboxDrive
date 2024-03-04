import UIKit

struct ProfileModel {
    var title: String?
    var buttonText: String?
    var disk: DiskInfo?
    
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        title = Constants.Texts.titleProfileScreen
        buttonText = Constants.Texts.PublichButtonText
    }
    
    mutating func loadDisk(_ disk: DiskInfo) {
        self.disk = disk
    }
}
