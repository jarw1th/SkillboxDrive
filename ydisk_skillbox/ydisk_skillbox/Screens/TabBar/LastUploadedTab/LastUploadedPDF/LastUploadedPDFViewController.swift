import UIKit
import SnapKit
import PDFKit

final class LastUploadedPDFViewController: UIViewController, LastUploadedPDFViewProtocol {
    // MARK: Variables
    private var presenter: LastUploadedPDFPresenterProtocol?
    
    private let pdfView = PDFView()
    
    convenience init(_ model: UploadedFiles?) {
        self.init(nibName: nil, bundle: nil)
        presenter = LastUploadedPDFPresenter(model!)
    }
    
    // MARK: Body
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.setView(self)
        
        setupUI()
    }
    
    // MARK: Functions
    private func setupUI() {
        view.backgroundColor = Constants.Colors.Black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButton))
        self.navigationItem.setTitle(title: (presenter?.getTitle())!, subtitle: (presenter?.getSubtitle())!)
        
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        
        pdfView.document = PDFDocument(url: (presenter?.getUrl())!)
        pdfView.autoScales = true
    }

    @objc private func editButton() {
        let model = presenter?.getInfo()
        self.navigationController?.pushViewController(RenameViewController(model), animated: true)
    }
}
