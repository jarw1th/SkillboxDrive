import Foundation
import Alamofire
import CoreData

protocol Requests {
    // Giving last uploaded files list
    func requestLastUploaded(completion: @escaping(([UploadedFiles]) -> ()))
    
    // Giving all files list in current path
    func requestAllFiles(path: String, completion: @escaping(([UploadedFiles]) -> ()))
    
    // Giving files that are published
    func requestPublicFiles(completion: @escaping(([UploadedFiles]) -> ()))
    
    // Giving disk information
    func requestDiskInfo(completion: @escaping((DiskInfo) -> ()))
}

protocol Deleting {
    // Delete the file by its path
    func deleteFile(path: String, completion: @escaping ((Bool) -> ()))
    
    // Remove file from published ones
    func deletePublic(path: String, completion: @escaping ((Bool) -> ()))
    
    // Cleaning documents directory and coredata entities
    func deleteEverything()
}

final class DataRequest {
    // MARK: Data Config
    private let config: DataConfig?
    
    // MARK: Variables
    private var token: String = String()    // My disk's token
    private var jsonDict: [String: Any]? = [:]      // Downloaded files saving here
    private var limit: Int = 8      // Starting limit for requests
    
    // MARK: CoreData Variables
    private let persistentContainter = NSPersistentContainer(name: "Model")
    
    // Last uploaded files data controller
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
    
    // All files by path data controller
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
    
    // Disk information data controller
    private lazy var fetchedResultsControllerDisk: NSFetchedResultsController<Disk> = {
        let fetchRequest = Disk.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "usedSpace", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainter.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
        }()
    
    // Published files data controller
    private lazy var fetchedResultsControllerPublic: NSFetchedResultsController<Public> = {
        let fetchRequest = Public.fetchRequest()
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
        // Setting config and token
        config = DataConfig()
        self.token = config?.getToken() ?? String()
        
        // Performing fetch for each entity
        persistentContainter.loadPersistentStores(completionHandler: { persistentStoreDescription, error in
            if let error = error {
                print(error, error.localizedDescription)
            } else {
                do {
                    try self.fetchedResultsControllerAll.performFetch()
                    try self.fetchedResultsController.performFetch()
                    try self.fetchedResultsControllerDisk.performFetch()
                    try self.fetchedResultsControllerPublic.performFetch()
                } catch {
                    print(error)
                }
            }
        })
    }
    
    // MARK: Functions (variables)
    // Change limit for file uploading (not working)
    func changeLimit(_ limit: Int) {
        self.limit = limit
    }
    
    // Return limit for file uploading (not working)
    func getLimit() -> Int {
        return self.limit
    }
    
    // MARK: Functions
    // Changing name of file
    func changeName(oldName: String, newName: String, path: String, completion: @escaping ((Bool) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(false)
            return
        }
        
        // Start file path with old name
        let from = path
        // New file path with new name
        let to = path.components(separatedBy: oldName).first! + newName
        
        let url = config?.getChangingNameLink(from: from, to: to) ?? String()
        // Dispatch group for request
        let group = DispatchGroup()
        
        group.enter()
        // Alamofire request
        AF.request(url,
                   method: .post,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                        completion(false)
                    } else {
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(true)
        })
    }
    
    // MARK: Private Functions
    // Loading cache files from request and deleting not existed files
    private func checkingLastUploadedCache(_ uploadedList: [UploadedFiles]) {
        // files - fetched objects for File entity; ids - array of ids; uploadedList = array of UploadedFiles objects
        var files = self.fetchedResultsController.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        // Removing objects if they are already existed
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        // Removing objects from cache if they are not in the request
        if ids.count < files.count {
            for el in files {
                persistentContainter.viewContext.delete(el)
                try? persistentContainter.viewContext.save()
            }
        }
        // End function if nothing to add to cache
        if ids.isEmpty {return}
        
        // Adding data to cache
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
    
    // Loading cache files from request and deleting not existed files
    private func checkingAllFilesCache(_ uploadedList: [UploadedFiles]) {
        // files - fetched objects for AllFiles entity; ids - array of ids; uploadedList = array of UploadedFiles objects
        var files = self.fetchedResultsControllerAll.fetchedObjects ?? []
        var paths: [String] = []
        uploadedList.forEach({ paths.append($0.path) })
        var uploadedList = uploadedList
        
        // Removing objects if they are already existed
        for el in files {
            let path = el.path ?? String()
            if paths.contains(path) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: paths.firstIndex(of: path)!)
                paths.remove(at: paths.firstIndex(of: path)!)
            }
        }
        
        // Removing objects from cache if they are not in the request
//        if ids.count < files.count {
//            for el in files {
//                persistentContainter.viewContext.delete(el)
//                try? persistentContainter.viewContext.save()
//            }
//        }
        
        // End function if nothing to add to cache
        if paths.isEmpty {return}
        
        // Adding data to cache
        for i in 0...paths.count-1 {
            let file = AllFiles.init(entity: NSEntityDescription.entity(forEntityName: "AllFiles",
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
    
    // Loading cache files from request and deleting not existed files
    private func checkingPublicCache(_ uploadedList: [UploadedFiles]) {
        // files - fetched objects for Public entity; ids - array of ids; uploadedList = array of UploadedFiles objects
        var files = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        // Removing objects if they are already existed
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        // Removing objects from cache if they are not in the request
        if ids.count < files.count {
            for el in files {
                persistentContainter.viewContext.delete(el)
                try? persistentContainter.viewContext.save()
            }
        }
        // End function if nothing to add to cache
        if ids.isEmpty {return}
        
        // Adding data to cache
        for i in 0...ids.count-1 {
            let file = Public.init(entity: NSEntityDescription.entity(forEntityName: "Public",
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
    
    // Loading cache files from request and deleting not existed files
    private func checkingDiskCache(_ disk: DiskInfo) {
        // files - fetched objects for Disk entity
        let files = self.fetchedResultsControllerDisk.fetchedObjects ?? []
        
        // Creating cache if files is empty
        if files.isEmpty {
            let file = Disk.init(entity: NSEntityDescription.entity(forEntityName: "Disk",
                                                                     in: self.persistentContainter.viewContext)!,
                                  insertInto: self.persistentContainter.viewContext)
            file.usedSpace = Int64(disk.usedSpace)
            file.totalSpace = Int64(disk.totalSpace)
            try? self.persistentContainter.viewContext.save()
            return
        }
        
        // Creating cache into 0 index of files
        files[0].usedSpace = Int64(disk.usedSpace)
        files[0].totalSpace = Int64(disk.totalSpace)
        try? self.persistentContainter.viewContext.save()
    }

    // Set request info into global private variable jsonDict
    private func dataRequest(url: String, group: DispatchGroup) {
        // Dispatch group enter
        group.enter()
        
        AF.request(url,
                   method: .get,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                    } else {
                        self.jsonDict = try? JSONSerialization.jsonObject(with: response.data!, 
                                                                          options: []) as? [String: Any]
                        group.leave()
                    }
                })
    }
    
    // Give cache for last uploaded files
    private func cacheLastUploadedFiles() -> [UploadedFiles] {
        // lastUploadedList - empty array; files - fetched objects for File entity
        var lastUploadedList: [UploadedFiles] = []
        let files = self.fetchedResultsController.fetchedObjects ?? []
        
        // Appending every object information into lastUploadedList array
        for file in files {
            let name = file.name ?? String()
            let preview = file.preview ?? Data()
            let date = file.created ?? Date()
            let size = Int(file.size)
            let path = file.path ?? String()
            let publicUrl = file.publicUrl ?? String()
            let type = file.type ?? String()
            let id = file.id ?? String()
            let url = file.url
            
            let gotData = UploadedFiles(name: name,
                                        preview: preview,
                                        created: date,
                                        size: size,
                                        path: path,
                                        publicUrl: publicUrl,
                                        type: type,
                                        id: id,
                                        url: url)
            
            lastUploadedList.append(gotData)
        }
        
        return lastUploadedList
    }
    
    // Give cache for all files
    private func cacheAllFiles(path: String) -> [UploadedFiles] {
        // allFilesList - empty array; files - fetched objects for AllFiles entity
        var allFilesList: [UploadedFiles] = []
        let files = self.fetchedResultsControllerAll.fetchedObjects ?? []
        var path = path
        // Deleting last / symbol when it gets disk:/
        if path.last == "/" {
            path.removeLast()
        }
        
        // Appending every object information into allFilesList array
        for file in files {
            let filePath = file.path?.components(separatedBy: "/" + (file.name ?? String())).first ?? String()
            // Checking if path is right path
            if path ==  filePath {
                let name = file.name ?? String()
                let preview = file.preview ?? Data()
                let date = file.created ?? Date()
                let size = Int(file.size)
                let path = file.path ?? String()
                let publicUrl = file.publicUrl ?? String()
                let type = file.type ?? String()
                let id = file.id ?? String()
                let url = file.url
                
                let gotData = UploadedFiles(name: name,
                                            preview: preview,
                                            created: date,
                                            size: size,
                                            path: path,
                                            publicUrl: publicUrl,
                                            type: type,
                                            id: id,
                                            url: url)
                
                allFilesList.append(gotData)
            }
        }
        
        return allFilesList
    }
    
    // Give cache for published files
    private func cachePublicFiles() -> [UploadedFiles] {
        // publicFilesList - empty array; files - fetched objects for Public entity
        var publicFilesList: [UploadedFiles] = []
        let files = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        
        // Appending every object information into publicFilesList array
        for file in files {
            let name = file.name ?? String()
            let preview = file.preview ?? Data()
            let date = file.created ?? Date()
            let size = Int(file.size)
            let path = file.path ?? String()
            let publicUrl = file.publicUrl ?? String()
            let type = file.type ?? String()
            let id = file.id ?? String()
            let url = file.url
            
            let gotData = UploadedFiles(name: name,
                                        preview: preview,
                                        created: date,
                                        size: size,
                                        path: path,
                                        publicUrl: publicUrl,
                                        type: type,
                                        id: id,
                                        url: url)
            
            publicFilesList.append(gotData)
        }
        
        return publicFilesList
    }
    
    // Give cache for disk information
    private func cacheDisk() -> DiskInfo {
        // files - fetched objects for Disk entity
        let files = self.fetchedResultsControllerDisk.fetchedObjects
        
        // Checking if there is files array
        guard let _ = files else {
            return DiskInfo(usedSpace: 0, totalSpace: 0)
        }
        // Returning 0 index of files array
        return DiskInfo(usedSpace: Int(files?[0].usedSpace ?? 0), totalSpace: Int(files?[0].totalSpace ?? 0))
    }

    // Downloading preview file and saving into document directory
    private func downloadPreview(name: String, path: String, completion: @escaping ((URL?) -> ())) {
        // documentUrl - URL for document directory with file name and extension
        var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentUrl.appendPathComponent("preview_" + name.trimmingCharacters(in: .whitespacesAndNewlines))
        let destination: DownloadRequest.Destination = { _, _ in
            return (documentUrl, [.removePreviousFile])
        }
        
        let url = config?.getDownloadingLink(path: path) ?? String()
        let group = DispatchGroup()
        
        dataRequest(url: url, group: group)
        
        group.notify(queue: DispatchQueue.global(), execute: {
            guard let href = URL(string: self.jsonDict?["href"] as? String ?? String()) else {return}
            // Alamofire donwload after getting link
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
                        completion(nil)
                    }
                })
        })
    }
}

// MARK: Requests protocol
extension DataRequest: Requests {
    // Request for last uploaded files
    func requestLastUploaded(completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning cached files if lost connection
            completion(cacheLastUploadedFiles())
            return
        }
        
        // lastUploadedList - empty array
        let url = config?.getLastUploadedLink() ?? String()
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Dispatch group for downloading preview
            let groupInner = DispatchGroup()
            let items = self.jsonDict?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                groupInner.enter()
                // Setting parametrs
                let name = item["name"] as? String ?? String()
                var preview: Data = Data()
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                var fileUrl: URL?
                
                // Checking if it needs to be downloaded (file extension checking)
                if Constants.Texts.fileExtensions.contains(name.fileExtension()) {
                    self.downloadPreview(name: name, path: path, completion: { url in
                        // Setting preview if it is image and url is not nil
                        let reasons = (Constants.Texts.imageExtensions.contains(name.fileExtension()))
                        if let data = try? Data(contentsOf: url!) {
                            preview = reasons ? data : Data()
                        }
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
                } else {
                    // Returning if it does not need to be downloaded
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
                }
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                // Saving and removing data cache
                self.checkingLastUploadedCache(lastUploadedList)
          
                completion(lastUploadedList)
            })
        })
    }
    
    // Request for all files
    func requestAllFiles(path: String, completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning cached files if lost connection
            completion(cacheAllFiles(path: path))
            return
        }
        
        // allList - empty array
        let url = config?.getAllFilesLink(path: path) ?? String()
        let group = DispatchGroup()
        var allList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Dispatch group for downloading preview
            let groupInner = DispatchGroup()
            let embedded = self.jsonDict?["_embedded"] as? [String: Any]
            let items = embedded?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                groupInner.enter()
                // Setting parametrs
                let name = item["name"] as? String ?? String()
                var preview: Data = Data()
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                var fileUrl: URL?
                
                // Checking if it needs to be downloaded (file extension checking)
                if Constants.Texts.fileExtensions.contains(name.fileExtension()) {
                    self.downloadPreview(name: name, path: path, completion: { url in
                        // Setting preview if it is image and url is not nil
                        let reasons = (Constants.Texts.imageExtensions.contains(name.fileExtension()))
                        if let data = try? Data(contentsOf: url!) {
                            preview = reasons ? data : Data()
                        }
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
                        allList.append(gotData)
                        groupInner.leave()
                    })
                } else {
                    // Returning if it does not need to be downloaded
                    let gotData = UploadedFiles(name: name,
                                                preview: preview,
                                                created: date,
                                                size: size,
                                                path: path,
                                                publicUrl: publicUrl,
                                                type: type,
                                                id: id,
                                                url: fileUrl)
                    allList.append(gotData)
                    groupInner.leave()
                }
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                // Saving and removing data cache
                self.checkingAllFilesCache(allList)
                
                completion(allList)
            })
        })
    }
    
    // Request for published files
    func requestPublicFiles(completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning cached files if lost connection
            completion(cachePublicFiles())
            return
        }
        
        // publicList - empty array
        let url = config?.getPublicFilesLink() ?? String()
        let group = DispatchGroup()
        var publicList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Dispatch group for downloading preview
            let groupInner = DispatchGroup()
            let items = self.jsonDict?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                groupInner.enter()
                // Setting parametrs
                let name = item["name"] as? String ?? String()
                var preview: Data?
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
                let size = item["size"] as? Int ?? Int()
                let path = item["path"] as? String ?? String()
                let publicUrl = item["public_url"] as? String ?? String()
                let type = item["type"] as? String ?? String()
                let id = item["md5"] as? String ?? String()
                
                // Checking if it needs to be downloaded (file extension checking)
                if Constants.Texts.fileExtensions.contains(name.fileExtension()) {
                    self.downloadPreview(name: name, path: path, completion: { url in
                        // Setting preview if it is image and url is not nil
                        let reasons = (Constants.Texts.imageExtensions.contains(name.fileExtension()))
                        if let data = try? Data(contentsOf: url!) {
                            preview = reasons ? data : Data()
                        }
                        let gotData = UploadedFiles(name: name,
                                                    preview: preview,
                                                    created: date,
                                                    size: size,
                                                    path: path,
                                                    publicUrl: publicUrl,
                                                    type: type,
                                                    id: id)
                        publicList.append(gotData)
                        groupInner.leave()
                    })
                } else {
                    // Returning if it does not need to be downloaded
                    let gotData = UploadedFiles(name: name,
                                                preview: preview,
                                                created: date,
                                                size: size,
                                                path: path,
                                                publicUrl: publicUrl,
                                                type: type,
                                                id: id)
                    publicList.append(gotData)
                    groupInner.leave()
                }
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                // Saving and removing data cache
                self.checkingPublicCache(publicList)
                
                completion(publicList)
            })
        })
    }
    
    // Request for disk information
    func requestDiskInfo(completion: @escaping((DiskInfo) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning cached information if lost connection
            completion(cacheDisk())
            return
        }
        
        let url = config?.getDiskInfoLink() ?? String()
        let group = DispatchGroup()
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Setting parametrs
            let usedSpace = self.jsonDict?["used_space"] as? Int ?? Int()
            let totalSpace = self.jsonDict?["total_space"] as? Int ?? Int()
            let diskInfo = DiskInfo(usedSpace: usedSpace, totalSpace: totalSpace)
            
            // Saving and removing data cache
            self.checkingDiskCache(diskInfo)
            
            completion(diskInfo)
        })
    }
}

// MARK: Deleting protocol
extension DataRequest: Deleting {
    // Delete file by its path
    func deleteFile(path: String, completion: @escaping ((Bool) -> ())) {
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning false if lost connection
            completion(false)
            return
        }
        
        let url = config?.getDeleteFileLink(path: path) ?? String()
        let group = DispatchGroup()
        
        group.enter()
        // Alamofire delete request
        AF.request(url,
                   method: .delete,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                        completion(false)
                        return
                    } else {
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Returning true
            completion(true)
        })
    }
    
    // Remove file from public list by its path
    func deletePublic(path: String, completion: @escaping ((Bool) -> ())) {
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            // Returning false if lost connection
            completion(false)
            return
        }
        
        let url = config?.getUnpublishFileLink(path: path) ?? String()
        let group = DispatchGroup()
        
        group.enter()
        // Alamofire delete request
        AF.request(url,
                   method: .put,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                        completion(false)
                        return
                    } else {
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            // Returning true
            completion(true)
        })
    }
    
    // Delete all cached data
    func deleteEverything() {
        // files - fetched objects for File entity; allFiles - fetched objects for AllFiles entity; disk - fetched objects for Disk entity; publicFiles - fetched objects for Public entity
        let files = self.fetchedResultsController.fetchedObjects ?? []
        let allFiles = self.fetchedResultsControllerAll.fetchedObjects ?? []
        let disk = self.fetchedResultsControllerDisk.fetchedObjects ?? []
        let publicFiles = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        
        // Deleting all objects in every entity
        for file in files {
            persistentContainter.viewContext.delete(file)
            try? persistentContainter.viewContext.save()
        }
        for file in allFiles {
            persistentContainter.viewContext.delete(file)
            try? persistentContainter.viewContext.save()
        }
        for file in publicFiles {
            persistentContainter.viewContext.delete(file)
            try? persistentContainter.viewContext.save()
        }
        for el in disk {
            persistentContainter.viewContext.delete(el)
            try? persistentContainter.viewContext.save()
        }
        
        // Getting document directory
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // Deleting every item in this directory
        do {
            let dir = try FileManager.default.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: [])
            for el in dir {
                try FileManager.default.removeItem(at: el)
            }
        } catch {
            print("error while deleting")
        }
        
    }
}
