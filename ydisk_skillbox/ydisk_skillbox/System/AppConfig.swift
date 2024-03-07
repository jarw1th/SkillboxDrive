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
    
    // Synchronize data
    func synchronize() {
        defaults.synchronize()
    }
}
