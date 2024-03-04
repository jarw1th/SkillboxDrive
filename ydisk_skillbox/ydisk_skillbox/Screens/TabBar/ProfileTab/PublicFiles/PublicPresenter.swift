import Foundation

protocol PublicPresenterProtocol: AnyObject {
    func setView(_ view: PublicViewProtocol)
    
    func getTitle() -> String
    
    func getFileName(for indexPath: IndexPath) -> String
    
    func getInfo(for indexPath: IndexPath) -> UploadedFiles
    
    func numberOfSections() -> Int
    
    func numberOfRowsInSection() -> Int
    
    func removePublic(for indexPath: IndexPath)
    
    func loadLastUploaded()
}

protocol PublicViewProtocol: AnyObject {
    func tableViewUpdate()
    
    func activityIndicatorStop()
    
    func stopRefreshing()
}

class PublicPresenter: PublicPresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: PublicViewProtocol?

    private var model = PublicModel()
    
    init() {
        dataRequest.requestPublicFiles(completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.activityIndicatorStop()
            }
        })
    }
    
    func setView(_ view: PublicViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        return model.title ?? String()
    }
    
    func getFileName(for indexPath: IndexPath) -> String {
        return model.filesList[indexPath.row].name
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
    
    func removePublic(for indexPath: IndexPath) {
        let file = model.filesList[indexPath.row]
        dataRequest.deletePublic(path: file.path, completion: { response in
            DispatchQueue.main.async {
                self.view?.activityIndicatorStop()
            }
        })
    }
    
    func loadLastUploaded() {
        dataRequest.requestPublicFiles(completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.stopRefreshing()
            }
        })
    }
}
