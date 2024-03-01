import Foundation
import Alamofire
import CoreData

class DataRequest {
    // MARK: Variables
    private let token = "y0_AgAAAAAn-NtRAAtgngAAAAD8tJn9AACQ5oedjzJG86CWLVl94BOUHptshg"
    private var jsonDict: [String: Any]? = [:]
    var isCached: Bool = false
    
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

    // MARK: Initial
    init() {
        persistentContainter.loadPersistentStores(completionHandler: { persistentStoreDescription, error in
            if let error = error {
                print(error, error.localizedDescription)
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print(error)
                }
            }
        })
    }
    
    // MARK: Functions
    func requestLastUploaded(completion: @escaping(([UploadedFiles]) -> ())) {
        let reachability = Reachability()
        if !reachability.isConnectedToNetwork() {
            completion(cacheRequest())
            return
        }
        let url = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=8"
        let group = DispatchGroup()
        var lastUploadedList: [UploadedFiles] = []
        
        dataRequest(url: url, group: group)
        
        group.notify(queue: DispatchQueue.global(), execute: {
            let items = self.jsonDict?["items"] as? Array<[String: Any]>
            items?.forEach({ item in
                let preview = try? Data(contentsOf: URL(string: item["preview"] as? String ?? String())!)
                let date = (item["created"] as? String ?? String()).toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ")
                let gotData = UploadedFiles(name: item["name"] as? String ?? String(),
                                           preview: preview ?? Data(),
                                           created: date ?? Date(),
                                           size: item["size"] as? Int ?? Int(),
                                           publicUrl: String())
                lastUploadedList.append(gotData)
            })
            
            self.checkingCoreDate(lastUploadedList)
            
            completion(lastUploadedList)
        })
    }
    
    // MARK: Private Functions
    private func checkingCoreDate(_ uploadedList: [UploadedFiles]) {
        let files = self.fetchedResultsController.fetchedObjects ?? []
        var nameList: [String] = []
        uploadedList.forEach({ nameList.append($0.name)})
        var uploadedList = uploadedList
        
        for el in files {
            if nameList.contains(el.name ?? String()) {
                uploadedList.remove(at: nameList.firstIndex(of: el.name ?? String())!)
                nameList.remove(at: nameList.firstIndex(of: el.name ?? String())!)
            }
        }
        if nameList.isEmpty {return}
        for i in 0...nameList.count-1 {
            let file = Files.init(entity: NSEntityDescription.entity(forEntityName: "Files",
                                                                     in: self.persistentContainter.viewContext)!,
                                  insertInto: self.persistentContainter.viewContext)
            file.name = uploadedList[i].name
            file.preview = uploadedList[i].preview
            file.created = uploadedList[i].created
            file.size = Int32(uploadedList[i].size)
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
    
    private func cacheRequest() -> [UploadedFiles] {
        var lastUploadedList: [UploadedFiles] = []
        let files = self.fetchedResultsController.fetchedObjects ?? []
        
        for file in files {
            let gotData = UploadedFiles(name: file.name ?? String(),
                                        preview: file.preview ?? Data(),
                                        created: file.created ?? Date(),
                                        size: Int(file.size),
                                        publicUrl: String())
            lastUploadedList.append(gotData)
        }
        
        return lastUploadedList
    }
}


