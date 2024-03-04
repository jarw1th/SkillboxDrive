import Foundation

protocol AllFilesPresenterProtocol: AnyObject {
    func setView(_ view: AllFilesViewProtocol)
    
    func getTitle() -> String
    
    func getInfo(for indexPath: IndexPath) -> UploadedFiles
    
    func numberOfSections() -> Int
    
    func numberOfRowsInSection() -> Int
    
    func loadAllFiles()
}

protocol AllFilesViewProtocol: AnyObject {
    func tableViewUpdate()
    
    func activityIndicatorStop()
    
    func stopRefreshing()
}

class AllFilesPresenter: AllFilesPresenterProtocol {
    private let dataRequest = DataRequest()
    
    private weak var view: AllFilesViewProtocol?
    private var path: String?

    private var model = AllFilesModel()
    
    init(path: String) {
        self.path = path
        dataRequest.requestAllFiles(path: path, completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.activityIndicatorStop()
            }
        })
    }
    
    func setView(_ view: AllFilesViewProtocol) {
        self.view = view
    }
    
    func getTitle() -> String {
        if path == "disk:/" {
            return model.title ?? String()
        } else {
            return path ?? String()
        }
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
    
    func loadAllFiles() {
        dataRequest.requestAllFiles(path: self.path ?? String(), completion: { dataList in
            self.model.loadFiles(dataList)
            DispatchQueue.main.async {
                self.view?.tableViewUpdate()
                self.view?.stopRefreshing()
            }
        })
    }
}
