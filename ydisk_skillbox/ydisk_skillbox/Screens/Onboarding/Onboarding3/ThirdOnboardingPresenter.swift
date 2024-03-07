import Foundation

final class ThirdOnboardingPresenter: OnboardingPresenterProtocol {
    private weak var view: OnboardingViewProtocol?
    
    private var model = ThirdOnboardingModel()
    
    init() {
        model.makeStatusList(id: 2, numberOfElements: 3)
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
