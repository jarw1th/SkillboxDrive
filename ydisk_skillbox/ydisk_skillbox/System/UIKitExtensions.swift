import UIKit

extension UIButton {
    // Extension for changing image color of button
    func setImageTintColor(_ color: UIColor?, for state: UIControl.State) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: state)
        self.tintColor = color ?? UIColor.systemBlue
    }
    
    // For .normal state
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
    
    // Extension for converting string to file extension (.pdf) string
    func fileExtension() -> String {
        let str: NSString = NSString(string: self.trimmingCharacters(in: .whitespacesAndNewlines))
        return str.pathExtension
    }
}

extension UINavigationItem {
    // Extension for setting title and subtitle
    func setTitle(title: String, subtitle: String) {
        let one = UILabel()
        one.text = title
        one.font = Constants.Fonts.Header2
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = Constants.Fonts.SmallText
        two.textAlignment = .center
        two.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        self.titleView = stackView
    }
}
