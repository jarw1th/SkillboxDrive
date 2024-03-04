import Foundation

protocol WebPresenterProtocol: AnyObject {
    func setView(_ view: WebViewProtocol)
    
    func getTitle() -> String
    
    func getSubtitle() -> String
    
    func getUrl() -> URL?
    
    func getPath() -> String
    
    func getInfo() -> UploadedFiles?
    
    func getPublicUrl() -> String
    
    func deleteFile()
}

protocol WebViewProtocol: AnyObject {
    func popScreen()
}

class WebPresenter: WebPresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: WebViewProtocol?

    private var model = WebModel()
    
    init(_ data: UploadedFiles) {
        self.model.loadFile(data)
    }
    
    func setView(_ view: WebViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        return model.title ?? String()
    }
    
    func getSubtitle() -> String {
        let date = model.file?.created.toString(with: "dd.MM.yy") ?? String()
        let time = model.file?.created.toString(with: "hh:mm") ?? String()
        return date + " " + time
    }
    
    func getUrl() -> URL? {
        return model.file?.url
    }
    
    func getPath() -> String {
        return model.file?.path ?? String()
    }
    
    func getInfo() -> UploadedFiles? {
        return model.file
    }
    
    func getPublicUrl() -> String {
        return model.file?.publicUrl ?? String()
    }
    
    func deleteFile() {
        let path = model.file?.path ?? String()
        dataRequest.deleteFile(path: path, completion: { response in
            DispatchQueue.main.async {
                if response {
                    self.view?.popScreen()
                }
            }
        })
    }
}
