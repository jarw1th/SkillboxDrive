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
        static let FirstOnboardingHeader2Text = "Теперь все ваши \nдокументы в одном месте"
        
        static let SecondOnboardingHeader2Text = "Доступ к файлам без интернета"
        
        static let ThirdOnboardingHeader2Text = "Делитесь вашими файлами с другими"
        
        static let ButtonText = "Далее"
        
        static let LoginButtonText = "Войти"
        
        static let PublichButtonText = "Опубликованные файлы"
        
        static let titleProfileScreen = "Профиль"
        
        static let titleLastUploadedScreen = "Последние"
        
        static let titleAllFilesScreen = "Все файлы"
        
        static let titlePublicScreen = "Опубликованные файлы"
        
        static let titleRename = "Переименовать"
        
        static let titlePDF = "PDF"
        
        static let titleImage = "Изображение"
        
        static let titleWeb = "Файл"
        
        static let imageExtensions = ["jpg", "jpeg", "png", "JPG", "JPEG", "PNG"]
        
        static let pdfExtensions = ["PDF", "pdf"]
        
        static let mcofficeExtensions = ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "DOC", "DOCX", "XLS", "XLSX", "PPT", "PPTX", "TXT"]
        
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
