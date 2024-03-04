import UIKit
import SnapKit

final class PublicViewController: UITableViewController {
    // MARK: Variables
    private var presenter: PublicPresenterProtocol?
    
    private let activityIndicator = SkillboxActivityIndicator(UIImage(data: Constants.Images.Loading!)!)
    private let tableRefreshControl = UIRefreshControl()
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PublicPresenter()
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction(indexPath: indexPath)
        }
    }
    
    private func deleteAction(indexPath: IndexPath) {
        let alert = UIAlertController(title: presenter?.getFileName(for: indexPath), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить публикацию", style: .destructive, handler: { _ in
            self.deleteAlert(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func deleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Удаление", message: "Вы уверены, что хотите удалить публикацию?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.activityIndicator.startAnimating()
            self.presenter?.removePublic(for: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .destructive))
        
        present(alert, animated: true)
    }
}

// MARK: View Protocol
extension PublicViewController: PublicViewProtocol {
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
