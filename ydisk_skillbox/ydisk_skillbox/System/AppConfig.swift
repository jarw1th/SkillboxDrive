import Foundation
import CoreData

final class AppConfig {
    // MARK: Variables
    private let defaults = UserDefaults.standard
    
    // MARK: Functions
    // Give authorization status
    func getAuthorizationStatus() -> Bool {
        return defaults.bool(forKey: "isAuthorized")
    }
    
    // Set authorization status
    func setAuthorizationStatus(_ isAuthorized: Bool) {
        defaults.setValue(false, forKey: "isAuthorized")
        defaults.setValue(isAuthorized, forKey: "isAuthorized")
    }
    
    // Give token
    func getToken() -> String {
        return defaults.string(forKey: "token") ?? String()
    }
    
    // Set token
    func setToken(_ token: String) {
        defaults.setValue(token, forKey: "token")
    }
    
    // Synchronize data
    func synchronize() {
        defaults.synchronize()
    }
}
