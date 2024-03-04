import Foundation

protocol RenamePresenterProtocol: AnyObject {
    func setView(_ view: RenameViewProtocol)
    
    func getTitle() -> String
    
    func getUrl() -> URL?
    
    func getImage() -> Data
    
    func getName() -> String
    
    func changeName(_ name: String)
}

protocol RenameViewProtocol: AnyObject {
    func activityIndicatorStart()
    
    func activityIndicatorStop()
    
    func popScreen()
    
    func errorMessage()
}

class RenamePresenter: RenamePresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: RenameViewProtocol?

    private var model = RenameModel()
    
    init(_ data: UploadedFiles) {
        self.model.loadFile(data)
    }
    
    func setView(_ view: RenameViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        return model.title ?? String()
    }
    
    func getUrl() -> URL? {
        return model.file?.url ?? URL(string: String())
    }
    
    func getImage() -> Data {
        return model.file?.preview ?? Data()
    }
    
    func getName() -> String {
        var name = model.file?.name
        let file = model.file?.name.fileExtension()
        name = name?.components(separatedBy: file!).first
        name?.removeLast()
        return name!
    }
    
    func changeName(_ name: String) {
        view?.activityIndicatorStart()
        let name = name + "." + (model.file?.name.fileExtension() ?? String())
        let path = model.file?.path ?? String()
        let oldName = model.file?.name ?? String()
        dataRequest.changeName(oldName: oldName, newName: name, path: path, completion: { response in
            DispatchQueue.main.async {
                if response {
                    self.view?.popScreen()
                    self.view?.activityIndicatorStop()
                } else {
                    self.view?.activityIndicatorStop()
                    self.view?.errorMessage()
                }
            }
        })
    }
}
