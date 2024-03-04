import Foundation

protocol ImagePresenterProtocol: AnyObject {
    func setView(_ view: ImageViewProtocol)
    
    func getTitle() -> String
    
    func getSubtitle() -> String
    
    func getImage() -> Data?
    
    func getPath() -> String
    
    func getInfo() -> UploadedFiles?
    
    func getPublicUrl() -> String
    
    func getFileUrl() -> URL?
    
    func deleteFile()
}

protocol ImageViewProtocol: AnyObject {
    func popScreen()
}

class ImagePresenter: ImagePresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: ImageViewProtocol?

    private var model = ImageModel()
    
    init(_ data: UploadedFiles) {
        self.model.loadFile(data)
    }
    
    func setView(_ view: ImageViewProtocol) {
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
    
    func getImage() -> Data? {
        return model.file?.preview ?? Data()
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
    
    func getFileUrl() -> URL? {
        return model.file?.url
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
