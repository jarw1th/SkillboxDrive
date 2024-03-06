import UIKit

class NoNetworkConnectionView: UIView {
    // MARK: Variables
    private let stackView: UIStackView = UIStackView()
    private var label: UILabel = UILabel()
    
    // MARK: Initialization
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    private func setup() {
        self.addSubview(stackView)
        let top = NSLayoutConstraint(item: stackView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 0)
        let bottom = NSLayoutConstraint(item: stackView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0)
        let leading = NSLayoutConstraint(item: stackView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 0)
        let trailing = NSLayoutConstraint(item: stackView,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 0)
        self.addConstraints([top, bottom, leading, trailing])
        
        stackView.addArrangedSubview(label)
        label.text = Constants.Texts.noConnection
        label.textAlignment = .center
        
        stackView.axis = .vertical
        stackView.backgroundColor = .systemRed
    }
}
