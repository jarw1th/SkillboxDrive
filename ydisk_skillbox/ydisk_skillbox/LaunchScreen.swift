import UIKit
import SnapKit

final class LaunchScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        
        let image = UIImageView()
        view.addSubview(image)
        
        image.snp.makeConstraints({ make in
            make.width.equalTo(195)
            make.height.equalTo(168)
            make.centerX.centerY.equalToSuperview()
        })
    }
}
