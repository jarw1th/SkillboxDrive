import UIKit

struct FirstOnboardingModel {
    var labelText: String?
    var image: Data?
    var ellipseImage: Data?
    var buttonText: String?
    var statusList: [Bool] = []
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        labelText = Constants.Texts.FirstOnboardingHeader2Text
        image = Constants.Images.FirstOnboardingImage
        ellipseImage = Constants.Images.EllipseScroller
        buttonText = Constants.Texts.ButtonText
    }
    
    // MARK: Active or Inactive status for ellipse indicator
    mutating func makeStatusList(id: Int, numberOfElements: Int) {
        statusList = []
        for i in 0...numberOfElements-1 {
            statusList.append(i == id)
        }
    }
}
