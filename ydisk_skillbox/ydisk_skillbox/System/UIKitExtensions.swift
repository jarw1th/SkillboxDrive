import UIKit

extension UIButton {
    // Extension for changing image color of button
    func setImageTintColor(_ color: UIColor?, for state: UIControl.State) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: state)
        self.tintColor = color ?? UIColor.systemBlue
    }
    
    func setImageTintColor(_ color: UIColor?) {
        setImageTintColor(color, for: .normal)
    }
}

extension UIView {
    // Extension for adding each view to subview from array
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    // Extension for adding each view to arranged subview from array
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

extension UIViewController {
    // Extension for hiding navigation bar
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Extension for showing navigation bar
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension UINavigationController {
    // Extension for reseting navigation stack
    func resetNavigationStack() {
        var navigationList = self.viewControllers
        let lastViewController = self.viewControllers.last
        navigationList.removeAll()
        navigationList.append(lastViewController!)
        self.viewControllers = navigationList
    }
}

extension Date {
    // Extension for converting date to string with custom format
    func toString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: self)
        return date
    }
}

extension String {
    // Extension for converting string to date with custom format
    func toDate(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        return date
    }
}
