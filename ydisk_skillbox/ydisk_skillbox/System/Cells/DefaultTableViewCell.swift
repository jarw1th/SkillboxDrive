import UIKit
import SnapKit

final class DefaultTableViewCell: UITableViewCell {
    // MARK: Variables
    private let stackView = UIStackView()
    private let filePreview = UIImageView()
    private let fileName = UILabel()
    private let fileInfo = UILabel()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Body
    override func prepareForReuse() {
        super.prepareForReuse()
        filePreview.image = UIImage()
        [fileName, fileInfo].forEach({ $0.text = nil })
        backgroundColor = .white
    }
    
    override var reuseIdentifier: String? {
        return "DefaultTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Functions
    func configure(with model: UploadedFiles?) {
        let model = model!
        let size = Int(model.size / 1024)
        let date = model.created.toString(with: "dd.MM.yy")
        let time = model.created.toString(with: "hh:mm")
        let image = model.preview == Data() ? Constants.Images.File! : model.preview
        filePreview.image = UIImage(data: image!)
        fileName.text = model.name
        fileInfo.text = String(size) + " кб " + date + " " + time
        fileInfo.isHidden = model.type == "dir"
    }
    
    // MARK: Private functions
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.leading.equalTo(6)
            make.bottom.trailing.equalTo(-6)
        })
        
        stackView.addSubviews([filePreview, fileName, fileInfo])
        filePreview.snp.makeConstraints({ make in
            make.width.equalTo(25)
            make.height.equalTo(22)
            make.leading.centerY.equalToSuperview()
        })
        fileName.snp.makeConstraints({ make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(filePreview.snp.trailing).inset(-15)
        })
        fileInfo.snp.makeConstraints({ make in
            make.bottom.trailing.equalToSuperview()
            make.top.equalTo(fileName.snp.bottom).inset(-2)
            make.leading.equalTo(filePreview.snp.trailing).inset(-15)
        })
        
        stackView.axis = .vertical
        
        filePreview.contentMode = .scaleToFill
        
        fileName.font = Constants.Fonts.MainBody
        fileName.textColor = Constants.Colors.Black
        
        fileInfo.font = Constants.Fonts.SmallText
        fileInfo.textColor = Constants.Colors.Icons
    }
}
