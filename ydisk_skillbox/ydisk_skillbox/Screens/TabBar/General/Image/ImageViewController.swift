import UIKit
import SnapKit

final class ImageViewController: UIViewController {
    // MARK: Variables
    private var presenter: ImagePresenterProtocol?
    
    private let image = UIImageView()
    private let deleteButton = UIButton()
    private let shareButton = UIButton()
    
    convenience init(_ model: UploadedFiles?) {
        self.init(nibName: nil, bundle: nil)
        presenter = ImagePresenter(model!)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Texts.editButton, style: .plain, target: self, action: #selector(editButton))
        self.navigationItem.setTitle(title: (presenter?.getTitle())!, subtitle: (presenter?.getSubtitle())!)
        self.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(image)
        image.frame = view.frame
        image.center = view.center
        image.contentMode = .scaleAspectFit
        
        view.addSubviews([deleteButton, shareButton])
        deleteButton.snp.makeConstraints({ make in
            make.bottom.equalTo(-36)
            make.trailing.equalTo(-64)
        })
        shareButton.snp.makeConstraints({ make in
            make.bottom.equalTo(-36)
            make.leading.equalTo(64)
        })
        
        deleteButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteButton.setImageTintColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        shareButton.setImageTintColor(.gray, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        
        image.image = UIImage(data: presenter?.getImage() ?? Data())
    }

    @objc private func editButton() {
        let model = presenter?.getInfo()
        self.navigationController?.pushViewController(RenameViewController(model), animated: true)
    }
    
    @objc private func deleteButtonAction() {
        let alert = UIAlertController(title: Constants.Texts.deleteText, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.Texts.deleteButton, style: .destructive, handler: { _ in
            self.presenter?.deleteFile()
        }))
        alert.addAction(UIAlertAction(title: Constants.Texts.cancelButton, style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func shareButtonAction() {
        let alert = UIAlertController(title: Constants.Texts.shareText, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.Texts.fileButton, style: .default, handler: { _ in
            guard let url = self.presenter?.getFileUrl() else {return}
            
            let urlItem: URL = url
            let activityViewController = UIActivityViewController(activityItems: [urlItem], applicationActivities: nil)
            
            activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
            activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .print]
            activityViewController.isModalInPresentation = true
            
            self.present(activityViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Constants.Texts.linkButton, style: .default, handler: { _ in
            guard let url = NSURL(string: (self.presenter?.getPublicUrl())!) else {return}
            
            let urlItem: NSURL = url
            let activityViewController = UIActivityViewController(activityItems: [urlItem], applicationActivities: nil)
            
            activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
            activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .print]
            activityViewController.isModalInPresentation = true
            
            self.present(activityViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: Constants.Texts.cancelButton, style: .cancel))
        
        present(alert, animated: true)
    }
}

extension ImageViewController: ImageViewProtocol {
    func popScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}
