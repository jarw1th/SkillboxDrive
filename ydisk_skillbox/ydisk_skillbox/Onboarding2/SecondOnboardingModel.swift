import UIKit

struct SecondOnboardingModel {
    var labelText: String?
    var image: Data?
    var ellipseImage: Data?
    var buttonText: String?
    var statusList: [Bool] = []
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        labelText = Constants.Texts.SecondOnboardingHeader2Text
        image = Constants.Images.SecondOnboardingImage
        ellipseImage = Constants.Images.EllipseScroller
        buttonText = Constants.Texts.ButtonText
    }
    
    mutating func makeStatusList(id: Int, numberOfElements: Int) {
        statusList = []
        for i in 0...numberOfElements-1 {
            statusList.append(i == id)
        }
    }
}
