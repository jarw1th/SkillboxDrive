import Foundation
import CoreData

class AppConfig {
    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    // MARK: Functions
    func getAuthorizationStatus() -> Bool {
        return defaults.bool(forKey: "isAuthorized")
    }
    
    func setAuthorizationStatus(_ isAuthorized: Bool) {
        defaults.set(false, forKey: "isAuthorized")
        print(getAuthorizationStatus())
        defaults.set(isAuthorized, forKey: "isAuthorized")
    }
}
