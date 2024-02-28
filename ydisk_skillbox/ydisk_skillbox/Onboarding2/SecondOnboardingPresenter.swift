import Foundation

protocol SecondOnboardingPresenterProtocol {
    func getLabelText() -> String
    
    func getImage() -> Data
    
    func getButtonText() -> String
    
    func checkActiveStatus(_ id: Int) -> Bool
}

class SecondOnboardingPresenter: SecondOnboardingPresenterProtocol {
    var model = SecondOnboardingModel()
    
    init() {
        model.makeStatusList(id: 1, numberOfElements: 3)
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
