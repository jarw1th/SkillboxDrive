import UIKit
import SnapKit

final class LastUploadedViewController: UITableViewController {
    // MARK: Variables
    private var presenter: LastUploadedPresenterProtocol?
    
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    private let tableRefreshControl = UIRefreshControl()
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LastUploadedPresenter()
        presenter?.setView(self)
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
        
        setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        title = presenter?.getTitle()
        
        tableView.separatorStyle = .none
        
        tableView.addSubview(tableRefreshControl)
        tableRefreshControl.addTarget(self, action: #selector(refresher), for: .valueChanged)
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        activityIndicator.startAnimating()
    }
    
    @objc private func refresher() {
        presenter?.loadLastUploaded()   
    }
    
    // MARK: TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCell", for: indexPath) as? DefaultTableViewCell
        let info = presenter?.getInfo(for: indexPath)
        cell?.configure(with: info)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter?.getInfo(for: indexPath).name.fileExtension() == "pdf" {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(LastUploadedPDFViewController(model), animated: true)
        }
    }
}

// MARK: View Protocol
extension LastUploadedViewController: LastUploadedViewProtocol {
    func tableViewUpdate() {
        tableView.reloadData()
    }
    
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }
    
    func stopRefreshing() {
        tableRefreshControl.endRefreshing()
    }
}
