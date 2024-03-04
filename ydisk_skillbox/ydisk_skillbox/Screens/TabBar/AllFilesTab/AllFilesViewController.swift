import UIKit
import SnapKit

final class AllFilesViewController: UITableViewController {
    // MARK: Variables
    private var presenter: AllFilesPresenterProtocol?
    private var path: String?
    
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    private let tableRefreshControl = UIRefreshControl()
    
    convenience init(path: String) {
        self.init(nibName: nil, bundle: nil)
        self.path = path
    }
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AllFilesPresenter(path: path ?? String())
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
        presenter?.loadAllFiles()
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
        let reason4 = presenter?.getInfo(for: indexPath).type == "dir"
        if reason1 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(PDFViewController(model), animated: true)
        } else if reason2 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(ImageViewController(model), animated: true)
        } else if reason3 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(WebViewController(model), animated: true)
        } else if reason4 {
            let model = presenter?.getInfo(for: indexPath)
            self.navigationController?.pushViewController(AllFilesViewController(path: model?.path ?? String()), animated: true)
        }
    }
}

// MARK: View Protocol
extension AllFilesViewController: AllFilesViewProtocol {
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
