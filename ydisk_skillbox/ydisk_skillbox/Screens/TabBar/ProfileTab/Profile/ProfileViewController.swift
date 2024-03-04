import UIKit
import SnapKit
import PieCharts

final class ProfileViewController: UIViewController {
    // MARK: Variables
    private var presenter: ProfilePresenterProtocol?
    
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    private let chartView = PieChart()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Texts.exitButton, style: .plain, target: self, action: #selector(deleteAction))
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        activityIndicator.startAnimating()
        
        view.addSubviews([chartView, textSize, textUsedSpace, textFreeSpace, button])
        chartView.snp.makeConstraints({ make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.centerX.equalToSuperview()
        })
        textSize.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.centerY.equalTo(chartView.snp.centerY)
            make.centerX.equalTo(chartView.snp.centerX)
        })
        textUsedSpace.snp.makeConstraints({ make in
            make.top.equalTo(chartView.snp.bottom).inset(-36)
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
        let alert = UIAlertController(title: Constants.Texts.titleProfileScreen, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.Texts.exitButton, style: .destructive, handler: { _ in
            self.deleteAlert()
        }))
        alert.addAction(UIAlertAction(title: Constants.Texts.cancelButton, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: Constants.Texts.exitButton, message: Constants.Texts.exitSubText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Texts.yesButton, style: .default, handler: { _ in
            self.presenter?.deleteProfile()
        }))
        alert.addAction(UIAlertAction(title: Constants.Texts.noButton, style: .destructive))
        
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
        let used = presenter?.getUsedSpace() ?? 0
        let free = presenter?.getFreeSpace() ?? 0
        chartView.models = [PieSliceModel(value: Double(used), color: Constants.Colors.Accent2!),
                            PieSliceModel(value: Double(free), color: Constants.Colors.Icons!)]
        textUsedSpace.text = "\(used) гб - \(Constants.Texts.usedSpace)"
        textFreeSpace.text = "\(free) гб - \(Constants.Texts.freeSpace)"
        
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
