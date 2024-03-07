import Foundation

protocol OnboardingPresenterProtocol: AnyObject {
    func setView(_ view: OnboardingViewProtocol)
    
    func getLabelText() -> String
    
    func getImage() -> Data
    
    func getButtonText() -> String
    
    func checkActiveStatus(_ id: Int) -> Bool
}

protocol OnboardingViewProtocol: AnyObject {}

final class FirstOnboardingPresenter: OnboardingPresenterProtocol {
    private weak var view: OnboardingViewProtocol?

    private var model = FirstOnboardingModel()
    
    init() {
        model.makeStatusList(id: 0, numberOfElements: 3)
    }
    
    func setView(_ view: OnboardingViewProtocol) {
        self.view = view
    }
    
    func getLabelText() -> String {
        return model.labelText ?? String()
    }
    
    func getImage() -> Data {
        return model.image ?? Data()
    }
    
    func getButtonText() -> String {
        return model.buttonText ?? String()
    }
    
    func checkActiveStatus(_ id: Int) -> Bool {
        return model.statusList[id]
    }
}
