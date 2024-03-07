import Foundation

protocol LoginPresenterProtocol: AnyObject {
    func setView(_ view: LoginViewProtocol)
    
    func getImage() -> Data
    
    func getButtonText() -> String
}

protocol LoginViewProtocol: AnyObject {}

final class LoginPresenter: LoginPresenterProtocol {
    private weak var view: LoginViewProtocol?
    
    private var model = LoginModel()
    
    func setView(_ view: LoginViewProtocol) {
        self.view = view
    }
    
    func getImage() -> Data {
        return model.image ?? Data()
    }
    
    func getButtonText() -> String {
        return model.buttonText ?? String()
    }
}
