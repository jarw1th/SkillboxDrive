import Foundation

protocol PDFPresenterProtocol: AnyObject {
    func setView(_ view: PDFViewProtocol)
    
    func getTitle() -> String
    
    func getSubtitle() -> String
    
    func getUrl() -> URL?
    
    func getPath() -> String
    
    func getInfo() -> UploadedFiles?
    
    func getPublicUrl() -> String
    
    func deleteFile()
}

protocol PDFViewProtocol: AnyObject {
    func popScreen()
}

final class PDFPresenter: PDFPresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: PDFViewProtocol?

    private var model = PDFModel()
    
    init(_ data: UploadedFiles) {
        self.model.loadFile(data)
    }
    
    func setView(_ view: PDFViewProtocol) {
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
