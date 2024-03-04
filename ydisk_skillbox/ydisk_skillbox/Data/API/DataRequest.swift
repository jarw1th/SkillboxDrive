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
    
    private lazy var fetchedResultsControllerDisk: NSFetchedResultsController<Disk> = {
        let fetchRequest = Disk.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainter.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
        }()
    
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
        
        let fields = "&fields=items.name,items.created,items.size,items.path,items.public_url,items.type,items.md5"
        let url = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=8" + fields + "&preview_size=25x&preview_crop=true"
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            print("api>")
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
                    let reasons = (name.fileExtension() == "jpeg" || name.fileExtension() == "jpg" || name.fileExtension() == "png") && (url != nil)
                    preview = reasons ? try! Data(contentsOf: url!) : Data()
                    fileUrl = url
                    print("check")
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
                print("<api cache>")
                self.checkingLastUploadedCache(lastUploadedList)
                print("<cache")
                completion(lastUploadedList)
            })
        })
    }
    
    func requestAllFiles(path: String, completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheAllFiles())
            return
        }
        
        let fields = "&fields=_embedded.items.name,_embedded.items.created,_embedded.items.size,_embedded.items.path,_embedded.items.public_url,_embedded.items.type,_embedded.items.md5"
        let url = "https://cloud-api.yandex.net/v1/disk/resources?path=" + path + fields + "&preview_size=25x&preview_crop=true"
        let group = DispatchGroup()
        var allList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            print("api>")
            let groupInner = DispatchGroup()
            let embedded = self.jsonDict?["_embedded"] as? [String: Any]
            let items = embedded?["items"] as? Array<[String: Any]>
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
                    let reasons = (name.fileExtension() == "jpeg" || name.fileExtension() == "jpg" || name.fileExtension() == "png") && (url != nil)
                    preview = reasons ? try! Data(contentsOf: url!) : Data()
                    fileUrl = url
                    print("check")
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
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                print("<api cache>")
                self.checkingAllFilesCache(allList)
                print("<cache")
                completion(allList)
            })
        })
    }
    
    func requestPublicFiles(completion: @escaping(([UploadedFiles]) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cachePublicFiles())
            return
        }
        
        let fields = "&fields=items.name,items.created,items.size,items.path,items.public_url,items.type,items.md5"
        let url = "https://cloud-api.yandex.net/v1/disk/resources/public?limit=12" + fields + "&preview_size=25x&preview_crop=true"
        let group = DispatchGroup()
        var publicList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            print("api>")
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
                
                self.downloadPreview(name: name, path: path, completion: { url in
                    let reasons = (name.fileExtension() == "jpeg" || name.fileExtension() == "jpg" || name.fileExtension() == "png") && (url != nil)
                    preview = reasons ? try! Data(contentsOf: url!) : Data()
                    print("check")
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
            })
            
            groupInner.notify(queue: DispatchQueue.global(), execute: {
                print("<api cache>")
                self.checkingPublicCache(publicList)
                print("<cache")
                completion(publicList)
            })
        })
    }
    
    func requestDiskInfo(completion: @escaping((DiskInfo) -> ())) {
        // Check network connection
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheDisk())
            return
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/"
        let group = DispatchGroup()
        
        dataRequest(url: url, group: group)
        
        // Notify on data request group
        group.notify(queue: DispatchQueue.global(), execute: {
            let usedSpace = self.jsonDict?["used_space"] as? Int ?? Int()
            let totalSpace = self.jsonDict?["total_space"] as? Int ?? Int()
            let diskInfo = DiskInfo(usedSpace: usedSpace, totalSpace: totalSpace)
            self.checkingDiskCache(diskInfo)
            completion(diskInfo)
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
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(true)
        })
    }
    
    func deleteFile(path: String, completion: @escaping ((Bool) -> ())) {
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(false)
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources?path=" + path
        let group = DispatchGroup()
        
        group.enter()
        AF.request(url,
                   method: .delete,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                    } else {
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(true)
        })
    }
    
    func deletePublic(path: String, completion: @escaping ((Bool) -> ())) {
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(false)
        }
        
        let url = "https://cloud-api.yandex.net/v1/disk/resources/unpublish?path=" + path
        let group = DispatchGroup()
        
        group.enter()
        AF.request(url,
                   method: .put,
                   headers: ["Content-Type": "application/json; charset=utf-8",
                             "Authorization": "OAuth \(token)"]).response(queue: DispatchQueue.global(),
                                                                           completionHandler: { response in
                    if let error = response.error {
                        print(error)
                    } else {
                        group.leave()
                    }
                })
        
        // Notify on group
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(true)
        })
    }
    
    func deleteEverything() {
        let files = self.fetchedResultsController.fetchedObjects ?? []
        let allFiles = self.fetchedResultsControllerAll.fetchedObjects ?? []
        let disk = self.fetchedResultsControllerDisk.fetchedObjects ?? []
        let publicFiles = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        
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
        
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let dir = try FileManager.default.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: [])
            for el in dir {
                try FileManager.default.removeItem(at: el)
            }
        } catch {
            print("error while deleting")
        }
        
    }
    
    // MARK: Private Functions
    private func checkingLastUploadedCache(_ uploadedList: [UploadedFiles]) {
        var files = self.fetchedResultsController.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        if ids.count < files.count {
            for el in files {
                persistentContainter.viewContext.delete(el)
                try? persistentContainter.viewContext.save()
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
        var files = self.fetchedResultsControllerAll.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        if ids.count < files.count {
            for el in files {
                persistentContainter.viewContext.delete(el)
                try? persistentContainter.viewContext.save()
            }
        }
        if ids.isEmpty {return}
        
        for i in 0...ids.count-1 {
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
    
    private func checkingPublicCache(_ uploadedList: [UploadedFiles]) {
        var files = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        var ids: [String] = []
        uploadedList.forEach({ ids.append($0.id) })
        var uploadedList = uploadedList
        
        for el in files {
            let id = el.id ?? String()
            if ids.contains(id) {
                files.remove(at: files.firstIndex(of: el)!)
                uploadedList.remove(at: ids.firstIndex(of: id)!)
                ids.remove(at: ids.firstIndex(of: id)!)
            }
        }
        
        if ids.count < files.count {
            for el in files {
                persistentContainter.viewContext.delete(el)
                try? persistentContainter.viewContext.save()
            }
        }
        if ids.isEmpty {return}
        
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
    
    private func checkingDiskCache(_ disk: DiskInfo) {
        let files = self.fetchedResultsControllerDisk.fetchedObjects ?? []
        
        if files.isEmpty {
            let file = Disk.init(entity: NSEntityDescription.entity(forEntityName: "Disk",
                                                                     in: self.persistentContainter.viewContext)!,
                                  insertInto: self.persistentContainter.viewContext)
            file.usedSpace = Int64(disk.usedSpace)
            file.totalSpace = Int64(disk.totalSpace)
            try? self.persistentContainter.viewContext.save()
            return
        }
        files[0].usedSpace = Int64(disk.usedSpace)
        files[0].totalSpace = Int64(disk.totalSpace)
        try? self.persistentContainter.viewContext.save()
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
    
    private func cachePublicFiles() -> [UploadedFiles] {
        var lastUploadedList: [UploadedFiles] = []
        let files = self.fetchedResultsControllerPublic.fetchedObjects ?? []
        
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
    
    private func cacheDisk() -> DiskInfo {
        let files = self.fetchedResultsControllerDisk.fetchedObjects
        
        guard let used = files else {
            return DiskInfo(usedSpace: 0, totalSpace: 0)
        }
        return DiskInfo(usedSpace: Int(files?[0].usedSpace ?? 0), totalSpace: Int(files?[0].totalSpace ?? 0))
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
            guard let href = URL(string: self.jsonDict?["href"] as? String ?? String()) else {return}
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


