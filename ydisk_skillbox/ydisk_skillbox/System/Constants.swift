import UIKit

// MARK: Constants
enum Constants {
    // MARK: Fonts
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
    
    // MARK: Color set
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
    
    // MARK: Texts
    enum Texts {
        static let FirstOnboardingHeader2Text = NSLocalizedString("FirstOnboardingHeader2Text", comment: "")
        
        static let SecondOnboardingHeader2Text = NSLocalizedString("SecondOnboardingHeader2Text", comment: "")
        
        static let ThirdOnboardingHeader2Text = NSLocalizedString("ThirdOnboardingHeader2Text", comment: "")
        
        static let ButtonText = NSLocalizedString("ButtonText", comment: "")
        
        static let LoginButtonText = NSLocalizedString("LoginButtonText", comment: "")
        
        static let PublichButtonText = NSLocalizedString("PublichButtonText", comment: "")
        
        static let titleProfileScreen = NSLocalizedString("titleProfileScreen", comment: "")
        
        static let titleLastUploadedScreen = NSLocalizedString("titleLastUploadedScreen", comment: "")
        
        static let titleAllFilesScreen = NSLocalizedString("titleAllFilesScreen", comment: "")
        
        static let titlePublicScreen = NSLocalizedString("titlePublicScreen", comment: "")
        
        static let titleRename = NSLocalizedString("titleRename", comment: "")
        
        static let titlePDF = NSLocalizedString("titlePDF", comment: "")
        
        static let titleImage = NSLocalizedString("titleImage", comment: "")
        
        static let titleWeb = NSLocalizedString("titleWeb", comment: "")
        
        static let usedSpace = NSLocalizedString("usedSpace", comment: "")
        
        static let freeSpace = NSLocalizedString("freeSpace", comment: "")
        
        static let exitButton = NSLocalizedString("exitButton", comment: "")
        
        static let cancelButton = NSLocalizedString("cancelButton", comment: "")
        
        static let yesButton = NSLocalizedString("yesButton", comment: "")
        
        static let noButton = NSLocalizedString("noButton", comment: "")
        
        static let exitText = NSLocalizedString("exitText", comment: "")
        
        static let exitSubText = NSLocalizedString("exitSubText", comment: "")
        
        static let shareText = NSLocalizedString("shareText", comment: "")
        
        static let linkButton = NSLocalizedString("linkButton", comment: "")
        
        static let fileButton = NSLocalizedString("fileButton", comment: "")
        
        static let editButton = NSLocalizedString("editButton", comment: "")
        
        static let doneButton = NSLocalizedString("doneButton", comment: "")
        
        static let deleteText = NSLocalizedString("deleteText", comment: "")
        
        static let deleteButton = NSLocalizedString("deleteButton", comment: "")
        
        static let imageExtensions = ["jpg", "jpeg", "png", "JPG", "JPEG", "PNG"]
        
        static let pdfExtensions = ["PDF", "pdf"]
        
        static let msofficeExtensions = ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "DOC", "DOCX", "XLS", "XLSX", "PPT", "PPTX", "TXT"]
        
        static let fileExtensions = ["jpg", "jpeg", "png", "JPG", "JPEG", "PNG", "PDF", "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "DOC", "DOCX", "XLS", "XLSX", "PPT", "PPTX", "TXT"]
    }
    
    // MARK: Images data
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
        
        static var Loading: Data? {
            return UIImage(named: "Loading")?.pngData()
        }
        
        static var Logo: Data? {
            return UIImage(named: "LogoLaunch")?.pngData()
        }
        
        static var File: Data? {
            return UIImage(named: "File")?.pngData()
        }
    }
}
