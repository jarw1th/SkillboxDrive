import Foundation
import Alamofire
import CoreData

class DataRequest {
    // MARK: Variables
    private let token = "y0_AgAAAAAn-NtRAAtgngAAAAD8tJn9AACQ5oedjzJG86CWLVl94BOUHptshg"
    private var jsonDict: [String: Any]? = [:]
    private var limit: Int = 8
    
    private let persistentContainter = NSPersistentContainer(name: "Model")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Files> = {
        let fetchRequest = Files.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainter.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
        }()
    
    private lazy var fetchedResultsControllerAll: NSFetchedResultsController<AllFiles> = {
        let fetchRequest = AllFiles.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainter.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
        }()

    // MARK: Initial
    init() {
        persistentContainter.loadPersistentStores(completionHandler: { persistentStoreDescription, error in
            if let error = error {
                print(error, error.localizedDescription)
            } else {
                do {
                    try self.fetchedResultsControllerAll.performFetch()
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print(error)
                }
            }
        })
    }
    
    // MARK: Functions (variables)
    func changeLimit(_ limit: Int) {
        self.limit = limit
    }
    
    func getLimit() -> Int {
        return self.limit
    }
    
    // MARK: Functions
    func requestLastUploaded(completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheLastUploadedFiles())
            return
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=8"
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            let groupInner = DispatchGroup()
            let items = self.jsonDict?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                groupInner.enter()
                let name = item["name"] as? String ?? String()
                var preview: Data?
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                var fileUrl: URL?
                
                self.downloadPreview(name: name, path: path, completion: { url in
                    preview = name.fileExtension() == "jpeg" ? try! Data(contentsOf: url!) : Data()
                    fileUrl = url
                    let gotData = UploadedFiles(name: name,
                                                preview: preview,
                                                created: date,
                                                size: size,
                                                path: path,
                                                publicUrl: publicUrl,
                                                type: type,
                                                id: id,
                                                url: fileUrl)
                    lastUploadedList.append(gotData)
                    groupInner.leave()
                })
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                self.checkingAllFilesCache(lastUploadedList)
                
                completion(lastUploadedList)
            })
        })
    }
    
    func requestAllFiles(completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheAllFiles())
            return
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources/files"
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            let items = self.jsonDict?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                let name = item["name"] as? String ?? String()
                let preview = Data()
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                
                let gotData = UploadedFiles(name: name,
                                            preview: preview,
                                            created: date,
                                            size: size,
                                            path: path,
                                            publicUrl: publicUrl,
                                            type: type,
                                            id: id)
                lastUploadedList.append(gotData)
            })
            
            self.checkingAllFilesCache(lastUploadedList)
            
            completion(lastUploadedList)
        })
    }
    
    func requestFolder(path: String, completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheAllFiles())
            return
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources?" + path
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            let groupInner = DispatchGroup()
            let embedded = self.jsonDict?["_embedded"] as? [String: Any]
            let items = embedded?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                groupInner.enter()
                let name = item["name"] as? String ?? String()
                var preview: Data = Data()
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                
                self.downloadPreview(name: name, path: path, completion: { url in
                    preview = try! Data(contentsOf: url!)
                    groupInner.leave()
                })
                
                let gotData = UploadedFiles(name: name,
                                            preview: preview,
                                            created: date,
                                            size: size,
                                            path: path,
                                            publicUrl: publicUrl,
                                            type: type,
                                            id: id)
                lastUploadedList.append(gotData)
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                self.checkingAllFilesCache(lastUploadedList)
                
                completion(lastUploadedList)
            })
        })
    }

    func changeName(oldName: String, newName: String, path: String, completion: @escaping ((Bool) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(false)
        }
        
        let from = path
        let to = path.components(separatedBy: oldName).first! + newName
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources/move?from=" + from + "&path=" + to + "&overwrite=true"
        let group = DispatchGroup()
        
        group.enter()
        AF.request(url,
                   method: .post,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                    } else {
                        self.jsonDict = try! JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(true)
        })
    }
    
    // MARK: Private Functions
    private func checkingLastUploadedCache(_ uploadedList: [UploadedFiles]) {
        let files = self.fetchedResultsController.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        if ids.isEmpty {return}
        for i in 0...ids.count-1 {
            let file = Files.init(entity: NSEntityDescription.entity(forEntityName: "Files",
                                                                     in: self.persistentContainter.viewContext)!,
                                  insertInto: self.persistentContainter.viewContext)
            file.name = uploadedList[i].name
            file.preview = uploadedList[i].preview
            file.created = uploadedList[i].created
            file.size = Int32(uploadedList[i].size)
            file.path = uploadedList[i].path
            file.publicUrl = uploadedList[i].publicUrl
            file.type = uploadedList[i].type
            file.id = uploadedList[i].id
            try? self.persistentContainter.viewContext.save()
        }
    }
    
    private func checkingAllFilesCache(_ uploadedList: [UploadedFiles]) {
        let files = self.fetchedResultsController.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        if ids.isEmpty {return}
        for i in 0...ids.count-1 {
            let file = AllFiles.init(entity: NSEntityDescription.entity(forEntityName: "Files",
                                                                     in: self.persistentContainter.viewContext)!,
                                  insertInto: self.persistentContainter.viewContext)
            file.name = uploadedList[i].name
            file.preview = uploadedList[i].preview
            file.created = uploadedList[i].created
            file.size = Int32(uploadedList[i].size)
            file.path = uploadedList[i].path
            file.publicUrl = uploadedList[i].publicUrl
            file.type = uploadedList[i].type
            file.id = uploadedList[i].id
            try? self.persistentContainter.viewContext.save()
        }
    }

    private func dataRequest(url: String, group: DispatchGroup) {
        group.enter()
        
        AF.request(url,
                   method: .get,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                    } else {
                        self.jsonDict = try! JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                        group.leave()
                    }
                })
    }
    
    private func cacheLastUploadedFiles() -> [UploadedFiles] {
        var lastUploadedList: [UploadedFiles] = []
        let files = self.fetchedResultsController.fetchedObjects ?? []
        
        for file in files {
            let name = file.name ?? String()
            let preview = file.preview ?? Data()
            let date = file.created ?? Date()
            let size = Int(file.size)
            let path = file.path ?? String()
            let publicUrl = file.publicUrl ?? String()
            let type = file.type ?? String()
            let id = file.id ?? String()
            
            let gotData = UploadedFiles(name: name,
                                        preview: preview,
                                        created: date,
                                        size: size,
                                        path: path,
                                        publicUrl: publicUrl,
                                        type: type,
                                        id: id)
            
            lastUploadedList.append(gotData)
        }
        
        return lastUploadedList
    }
    
    private func cacheAllFiles() -> [UploadedFiles] {
        var lastUploadedList: [UploadedFiles] = []
        let files = self.fetchedResultsControllerAll.fetchedObjects ?? []
        
        for file in files {
            let name = file.name ?? String()
            let preview = file.preview ?? Data()
            let date = file.created ?? Date()
            let size = Int(file.size)
            let path = file.path ?? String()
            let publicUrl = file.publicUrl ?? String()
            let type = file.type ?? String()
            let id = file.id ?? String()
            
            let gotData = UploadedFiles(name: name,
                                        preview: preview,
                                        created: date,
                                        size: size,
                                        path: path,
                                        publicUrl: publicUrl,
                                        type: type,
                                        id: id)
            
            lastUploadedList.append(gotData)
        }
        
        return lastUploadedList
    }
    
    private func cacheFileLink(id: String) -> URL? {
        return findNeededObject(id)?.url
    }
    
    private func findNeededObject(_ id: String) -> Files? {
        let objects = self.fetchedResultsController.fetchedObjects
        for object in objects! {
            if object.id == id {
                return object
            }
        }
        return nil
    }

    private func downloadPreview(name: String, path: String, completion: @escaping ((URL?) -> ())) {
        var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentUrl.appendPathComponent("preview_" + name.trimmingCharacters(in: .whitespacesAndNewlines))
        let destination: DownloadRequest.Destination = { _, _ in
            return (documentUrl, [.removePreviousFile])
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources/download?path=" + path
        let group = DispatchGroup()
        
        dataRequest(url: url, group: group)
        
        group.notify(queue: DispatchQueue.global(), execute: {
            let href = URL(string: self.jsonDict?["href"] as? String ?? String())!
            AF.download(
                href,
                method: .get,
                encoding: JSONEncoding.default,
                to: destination).response(completionHandler:{ response in
                    switch response.result {
                    case .success(let url):
                        completion(url)
                    default:
                        print("error")
                    }
                })
        })
    }
}


