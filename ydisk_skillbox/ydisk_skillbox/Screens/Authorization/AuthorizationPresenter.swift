import Foundation

protocol AuthorizationPresenterProtocol {
    func setView(_ view: AuthorizationViewProtocol)
    
    func getDataAuthorization(completion: @escaping ((URLRequest) -> Void))
    
    func getToken(from url: URL, completion: () -> Void)
}

protocol AuthorizationViewProtocol: AnyObject {}

final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    private weak var view: AuthorizationViewProtocol?
    
    private let dataRequest = DataRequest()
    private let appConfig = AppConfig()
    
    func setView(_ view: AuthorizationViewProtocol) {
        self.view = view
    }
    
    func getDataAuthorization(completion: @escaping ((URLRequest) -> Void)) {
        dataRequest.requestAuthorization(completion: { request in
            guard let request = request else { return }
            completion(request)
        })
    }
    
    func getToken(from url: URL, completion: () -> Void) {
        let targetString = url.absoluteString.replacingOccurrences(
            of: "#",
            with: "?"
        )
        let components = URLComponents(string: targetString)
        let token = components?.queryItems?.first(
            where: { $0.name == "access_token" }
        )
        if let token = token?.value {
            appConfig.setToken(token)
            appConfig.synchronize()
            completion()
        }
    }
}
