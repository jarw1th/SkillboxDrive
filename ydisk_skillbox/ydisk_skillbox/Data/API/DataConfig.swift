import Foundation

final class DataConfig {
    private let token = "y0_AgAAAAAn-NtRAAtgngAAAAD8tJn9AACQ5oedjzJG86CWLVl94BOUHptshg"
    
    func getToken() -> String {
        return self.token
    }
    
    func getChangingNameLink(from: String, to: String) -> String {
        let result = "https://cloud-api.yandex.net/v1/disk/resources/move?from=" + from + "&path=" + to + "&overwrite=true"
        return result 
    }
    
    func getDownloadingLink(path: String) -> String {
        let result = "https://cloud-api.yandex.net/v1/disk/resources/download?path=" + path
        return result
    }
    
    func getLastUploadedLink() -> String {
        let fields = "&fields=items.name,items.created,items.size,items.path,items.public_url,items.type,items.md5"
        let result = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=8" + fields + "&preview_size=25x&preview_crop=true"
        return result
    }
    
    func getAllFilesLink(path: String) -> String {
        let fields = "&fields=_embedded.items.name,_embedded.items.created,_embedded.items.size,_embedded.items.path,_embedded.items.public_url,_embedded.items.type,_embedded.items.md5"
        let result = "https://cloud-api.yandex.net/v1/disk/resources?path=" + path + fields + "&preview_size=25x&preview_crop=true"
        return result
    }
    
    func getPublicFilesLink() -> String {
        let fields = "&fields=items.name,items.created,items.size,items.path,items.public_url,items.type,items.md5"
        let result = "https://cloud-api.yandex.net/v1/disk/resources/public?limit=12" + fields + "&preview_size=25x&preview_crop=true"
        return result
    }
    
    func getDiskInfoLink() -> String {
        let result = "https://cloud-api.yandex.net/v1/disk/"
        return result
    }
    
    func getDeleteFileLink(path: String) -> String {
        let result = "https://cloud-api.yandex.net/v1/disk/resources?path=" + path
        return result
    }
    
    func getUnpublishFileLink(path: String) -> String {
        let result = "https://cloud-api.yandex.net/v1/disk/resources/unpublish?path=" + path
        return result
    }
}
