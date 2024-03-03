import Foundation

protocol LastUploadedPDFPresenterProtocol: AnyObject {
    func setView(_ view: LastUploadedPDFViewProtocol)
    
    func getTitle() -> String
    
    func getSubtitle() -> String
    
    func getUrl() -> URL?
    
    func getPath() -> String
    
    func getInfo() -> UploadedFiles?
}

protocol LastUploadedPDFViewProtocol: AnyObject {}

class LastUploadedPDFPresenter: LastUploadedPDFPresenterProtocol {
    private weak var view: LastUploadedPDFViewProtocol?

    private var model = LastUploadedPDFModel()
    
    init(_ data: UploadedFiles) {
        self.model.loadFile(data)
    }
    
    func setView(_ view: LastUploadedPDFViewProtocol) {
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
        return model.file?.url ?? URL(string: String())
    }
    
    func getPath() -> String {
        return model.file?.path ?? String()
    }
    
    func getInfo() -> UploadedFiles? {
        return model.file
    }
}
