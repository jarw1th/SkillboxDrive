import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func setView(_ view: ProfileViewProtocol)
    
    func getTitle() -> String
    
    func getButtonText() -> String
    
    func getTotalSpace() -> Int
    
    func getUsedSpace() -> Int
    
    func getFreeSpace() -> Int
    
    func getProgress() -> Float
    
    func deleteProfile()
}

protocol ProfileViewProtocol: AnyObject {
    func loadUI()
    
    func activityIndicatorStop()
    
    func popScreen()
}

class ProfilePresenter: ProfilePresenterProtocol {
    private let appConfig: AppConfig = AppConfig()
    
    private let dataRequest = DataRequest()
    
    private weak var view: ProfileViewProtocol?

    private var model = ProfileModel()
    
    init() {
        dataRequest.requestDiskInfo(completion: { dataList in
            self.model.loadDisk(dataList)
            DispatchQueue.main.async {
                self.view?.activityIndicatorStop()
                self.view?.loadUI()
            }
        })
    }
    
    func setView(_ view: ProfileViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        return model.title ?? String()
    }
    
    func getButtonText() -> String {
        return model.buttonText ?? String()
    }
    
    func getTotalSpace() -> Int {
        let result = (model.disk?.totalSpace ?? 0) / 1000000000
        return result
    }
    
    func getUsedSpace() -> Int {
        let result = (model.disk?.usedSpace ?? 0) / 1000000000
        return result
    }
    
    func getFreeSpace() -> Int {
        let free = (model.disk?.totalSpace ?? 0) - (model.disk?.usedSpace ?? 0)
        let result = free / 1000000000
        return result
    }
    
    func getProgress() -> Float {
        let used = Float(model.disk?.usedSpace ?? 0)
        let total = Float(model.disk?.totalSpace ?? 0)
        let result = used / total
        return result
    }
    
    func deleteProfile() {
        appConfig.setAuthorizationStatus(false)
        appConfig.synchronize()
        dataRequest.deleteEverything()
        view?.popScreen()
    }
}
