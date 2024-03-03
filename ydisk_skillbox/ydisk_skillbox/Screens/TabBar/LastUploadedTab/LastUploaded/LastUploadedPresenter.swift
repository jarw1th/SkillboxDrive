import Foundation

protocol LastUploadedPresenterProtocol: AnyObject {
    func setView(_ view: LastUploadedViewProtocol)
    
    func getTitle() -> String
    
    func getInfo(for indexPath: IndexPath) -> UploadedFiles
    
    func numberOfSections() -> Int
    
    func numberOfRowsInSection() -> Int
    
    func loadLastUploaded()
}

protocol LastUploadedViewProtocol: AnyObject {
    func tableViewUpdate()
    
    func activityIndicatorStop()
    
    func stopRefreshing()
}

class LastUploadedPresenter: LastUploadedPresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: LastUploadedViewProtocol?

    private var model = LastUploadedModel()
    
    init() {
        dataRequest.requestLastUploaded(completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.activityIndicatorStop()
            }
        })
    }
    
    func setView(_ view: LastUploadedViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        return model.title ?? String()
    }
    
    func getInfo(for indexPath: IndexPath) -> UploadedFiles {
        return model.filesList[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int {
        return model.filesList.count
    }
    
    func loadLastUploaded() {
        dataRequest.requestLastUploaded(completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.stopRefreshing()
            }
        })
    }
}
