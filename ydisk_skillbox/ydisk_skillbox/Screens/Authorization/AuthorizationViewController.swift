import UIKit
import WebKit
import SnapKit

final class AuthorizationViewController: UIViewController, AuthorizationViewProtocol {
    private let webView = WKWebView()
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    
    private var presenter: AuthorizationPresenterProtocol?

    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthorizationPresenter()
        presenter?.setView(self)
        webView.navigationDelegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        
        presenter?.getDataAuthorization(completion: { request in
            self.activityIndicator.stopAnimating()
            self.webView.load(request)
        })
    }
}

// MARK: WKNavigation delegate
extension AuthorizationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            presenter?.getToken(from: url, completion: {
                if let presentingNavController = presentingViewController as? UINavigationController {
                    presentingNavController.pushViewController(TabBarController(), animated: true)
                }
                dismiss(animated: true)
            })
        }
        decisionHandler(.allow)
    }
}
