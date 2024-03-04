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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        title = presenter?.getTitle()
        self.tabBarController?.tabBar.isHidden = false
        
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
        let fileExtension = presenter?.getInfo(for: indexPath).name.fileExtension() ?? String()
        let reason1 = Constants.Texts.pdfExtensions.contains(fileExtension)
        let reason2 = Constants.Texts.imageExtensions.contains(fileExtension)
        let reason3 = Constants.Texts.msofficeExtensions.contains(fileExtension)
        if reason1 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(PDFViewController(model), animated: true)
        } else if reason2 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(ImageViewController(model), animated: true)
        } else if reason3 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(WebViewController(model), animated: true)
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
