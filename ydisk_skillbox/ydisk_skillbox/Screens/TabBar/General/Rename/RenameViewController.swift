import UIKit
import SnapKit
import PDFKit

final class RenameViewController: UIViewController {
    // MARK: Variables
    private var presenter: RenamePresenterProtocol?
    
    private let textField = UITextField()
    private let image = UIImageView()
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    
    convenience init(_ model: UploadedFiles?) {
        self.init(nibName: nil, bundle: nil)
        presenter = RenamePresenter(model!)
    }
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.setView(self)
        
        setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        title = presenter?.getTitle()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Texts.doneButton, style: .plain, target: self, action: #selector(doneButton))
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        
        view.addSubviews([image, textField])
        image.snp.makeConstraints({ make in
            make.width.equalTo(25)
            make.height.equalTo(22)
            make.leading.equalTo(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(36)
        })
        textField.snp.makeConstraints({ make in
            make.leading.equalTo(image.snp.trailing).inset(-16)
            make.centerY.equalTo(image.snp.centerY)
            make.trailing.equalTo(16)
        })
        
        let data = presenter?.getImage() == Data() ? Constants.Images.File! : presenter?.getImage()
        image.image = UIImage(data: data!)
        
        textField.placeholder = presenter?.getName()
    }

    @objc private func doneButton() {
        let name = textField.text ?? presenter?.getName()
        presenter?.changeName(name!)
    }
}

extension RenameViewController: RenameViewProtocol {
    func activityIndicatorStart() {
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }
    
    func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorMessage() {
        textField.placeholder = "error"
        textField.text = "error"
        textField.allowsEditingTextAttributes = false
    }
}
