import UIKit

enum Constants {
    enum Fonts {
        static var Header1: UIFont {
            return UIFont.systemFont(ofSize: 26, weight: .semibold)
        }
        
        static var Header2: UIFont {
            return UIFont.systemFont(ofSize: 17, weight: .medium)
        }
        
        static var MainBody: UIFont {
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        
        static var SmallText: UIFont {
            return UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        static var ButtonText: UIFont {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    enum Colors {
        static var Accent1: UIColor? {
            return UIColor(named: "Accent1")
        }
        
        static var Accent2: UIColor? {
            return UIColor(named: "Accent2")
        }
        
        static var Black: UIColor? {
            return UIColor.black
        }
        
        static var Icons: UIColor? {
            return UIColor(named: "Icons")
        }
        
        static var White: UIColor? {
            return UIColor.white
        }
    }
    
    enum Texts {
        static let FirstOnboardingHeader2Text = "Теперь все ваши \nдокументы в одном месте"
        
        static let SecondOnboardingHeader2Text = "Доступ к файлам без интернета"
        
        static let ThirdOnboardingHeader2Text = "Делитесь вашими файлами с другими"
        
        static let ButtonText = "Далее"
    }
    
    enum Images {
        static var FirstOnboardingImage: Data? {
            return UIImage(named: "FilesImage")?.pngData()
        }
        
        static var EllipseScroller: Data? {
            return UIImage(named: "Ellipse")?.pngData()
        }
        
        static var SecondOnboardingImage: Data? {
            return UIImage(named: "FileImage")?.pngData()
        }
        
        static var ThirdOnboardingImage: Data? {
            return UIImage(named: "PencilImage")?.pngData()
        }
    }
}
