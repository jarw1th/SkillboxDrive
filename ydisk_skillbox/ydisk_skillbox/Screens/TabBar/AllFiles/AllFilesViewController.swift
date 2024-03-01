import UIKit
import SnapKit

final class AllFilesViewController: UITableViewController {
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        title = "gg"
        
        hideNavigationBar()
    }
}
