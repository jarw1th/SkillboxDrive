import UIKit
import SnapKit
import Darwin

final class ProfileViewController: UIViewController {
    // MARK: Variables
    private var presenter: ProfilePresenterProtocol?
    
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    private let progressBar = UIProgressView()
    private let textSize = UILabel()
    private let textUsedSpace = UILabel()
    private let textFreeSpace = UILabel()
    private let button = UIButton()
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter()
        presenter?.setView(self)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        title = presenter?.getTitle()
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(deleteAction))
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        activityIndicator.startAnimating()
        
        view.addSubviews([textSize, progressBar, textUsedSpace, textFreeSpace, button])
        textSize.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.centerX.equalToSuperview()
        })
        progressBar.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.height.equalTo(20)
            make.top.equalTo(textSize.snp.bottom).inset(-16)
            make.centerX.equalToSuperview()
        })
        textUsedSpace.snp.makeConstraints({ make in
            make.top.equalTo(progressBar.snp.bottom).inset(-36)
            make.leading.equalTo(36)
            make.trailing.equalTo(-36)
        })
        textFreeSpace.snp.makeConstraints({ make in
            make.top.equalTo(textUsedSpace.snp.bottom).inset(-24)
            make.leading.equalTo(36)
            make.trailing.equalTo(-36)
        })
        button.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.top.equalTo(textFreeSpace.snp.bottom).inset(-36)
            make.centerX.equalToSuperview()
        })
        
        textSize.textAlignment = .center
        textSize.font = Constants.Fonts.Header2
        
        progressBar.progressTintColor = Constants.Colors.Accent2
        progressBar.trackTintColor = Constants.Colors.Icons
        progressBar.progressViewStyle = .bar
        
        textUsedSpace.font = Constants.Fonts.MainBody
        textUsedSpace.textColor = Constants.Colors.Accent2
        
        textFreeSpace.font = Constants.Fonts.MainBody
        textFreeSpace.textColor = Constants.Colors.Icons
        
        button.backgroundColor = Constants.Colors.Icons
        button.setTitle(presenter?.getButtonText(), for: .normal)
        button.setTitleColor(Constants.Colors.White, for: .normal)
        button.titleLabel?.font = Constants.Fonts.ButtonText
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
    }
    
    @objc private func deleteAction() {
        let alert = UIAlertController(title: "Профиль", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
            self.deleteAlert()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.presenter?.deleteProfile()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .destructive))
        
        present(alert, animated: true)
    }
    
    @objc func pushViewController() {
        self.navigationController?.pushViewController(PublicViewController(), animated: true)
    }
}

// MARK: View Protocol
extension ProfileViewController: ProfileViewProtocol {
    func loadUI() {
        textSize.text = "\(presenter?.getTotalSpace() ?? 0) гб"
        progressBar.setProgress(presenter?.getProgress() ?? 0.0, animated: true)
        textUsedSpace.text = "\(presenter?.getUsedSpace() ?? 0) гб - занято"
        textFreeSpace.text = "\(presenter?.getFreeSpace() ?? 0) гб - свободно"
        
        view.layoutIfNeeded()
    }
    
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }
    
    func popScreen() {
        let window = UIApplication.shared.windows.first
        window?.rootViewController = UINavigationController(rootViewController: FirstOnboardingViewController())
        self.navigationController?.popToRootViewController(animated: true)
    }
}