import UIKit

struct LoginModel {
    var image: Data?
    var buttonText: String?
    
    init() {
        makeModelInfo()
    }
    
    private mutating func makeModelInfo() {
        image = Constants.Images.Logo
        buttonText = Constants.Texts.LoginButtonText
    }
}
