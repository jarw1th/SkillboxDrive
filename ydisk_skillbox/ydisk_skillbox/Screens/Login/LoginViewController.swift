import UIKit
import SnapKit

final class LoginViewController: UIViewController, LoginViewProtocol {
    // MARK: Presenter
    private var presenter: LoginPresenterProtocol?
    
    private let button = UIButton()
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LoginPresenter()
        presenter?.setView(self)
        setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        
        let stackView = UIStackView()
        let image = UIImageView()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        
        stackView.addSubviews([image, button])
        
        image.snp.makeConstraints({ make in
            make.width.equalTo(195)
            make.height.equalTo(168)
            make.centerX.equalToSuperview()
            make.top.equalTo(271.05)
        })
        button.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(image.snp.bottom).inset(-230.95)
        })
        
        stackView.axis = .vertical
        
        image.image = UIImage(data: presenter?.getImage() ?? Data())
        
        button.backgroundColor = Constants.Colors.Accent1
        button.setTitle(presenter?.getButtonText(), for: .normal)
        button.setTitleColor(Constants.Colors.White, for: .normal)
        button.titleLabel?.font = Constants.Fonts.ButtonText
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
    }
    
    @objc private func pushViewController() {
        let reachability: Reachability = Reachability()
        if reachability.isConnectedToNetwork() {
            let appConfig: AppConfig = AppConfig()
            appConfig.setAuthorizationStatus(true)
            appConfig.synchronize()
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        } else {
            button.setTitle("Отсутсвует соединение", for: .normal)
            button.backgroundColor = Constants.Colors.Icons
        }
    }
}
