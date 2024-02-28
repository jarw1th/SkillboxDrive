import UIKit
import SnapKit

final class FirstOnboardingViewController: UIViewController {
    var presenter: FirstOnboardingPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FirstOnboardingPresenter()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.White
        hideNavigationBar()
        
        let stackView = UIStackView()
        let image = UIImageView()
        let label = UILabel()
        let ellipseStackView = UIStackView()
        let ellipseButtons: [UIButton] = makeButtonList(3)
        let button = UIButton()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        
        stackView.addSubviews([image, label, ellipseStackView, button])
        
        image.snp.makeConstraints({ make in
            make.width.equalTo(149)
            make.height.equalTo(147)
            make.centerX.equalToSuperview()
            make.top.equalTo(228)
        })
        label.snp.makeConstraints({ make in
            make.width.equalTo(234)
            make.centerX.equalToSuperview()
            make.top.equalTo(image.snp.bottom).inset(-64)
        })
        ellipseStackView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).inset(-143)
        })
        button.snp.makeConstraints({ make in
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(ellipseStackView.snp.bottom).inset(-41)
        })
        
        for button in ellipseButtons {
            ellipseStackView.addArrangedSubview(button)
            
            button.snp.makeConstraints({ make in
                make.width.equalTo(8)
                make.height.equalTo(8)
            })
            
            button.setImage(UIImage(data: Constants.Images.EllipseScroller ?? Data()), for: .normal)
            button.setImageTintColor((presenter?.checkActiveStatus(ellipseButtons.firstIndex(of: button)!) ?? false) ? Constants.Colors.Accent1 : Constants.Colors.Icons)

        }
        
        stackView.axis = .vertical
        
        image.image = UIImage(data: presenter?.getImage() ?? Data())
        
        label.font = Constants.Fonts.Header2
        label.text = presenter?.getLabelText()
        label.numberOfLines = 0
        label.textColor = Constants.Colors.Black
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.contentMode = .bottom
        
        ellipseStackView.axis = .horizontal
        ellipseStackView.spacing = 10
        
        button.backgroundColor = Constants.Colors.Accent1
        button.setTitle(presenter?.getButtonText(), for: .normal)
        button.setTitleColor(Constants.Colors.White, for: .normal)
        button.titleLabel?.font = Constants.Fonts.ButtonText
        button.layer.cornerRadius = 10
        button.addAction(UIAction(handler: { action in
            self.navigationController?.pushViewController(SecondOnboardingViewController(), animated: true)
        }), for: .touchUpInside)
    }
    
    private func makeButtonList(_ numberOfButtons: Int) -> [UIButton] {
        var buttonList: [UIButton] = []
        for _ in 0...numberOfButtons-1 {
            buttonList.append(UIButton())
        }
        return buttonList
    }
}
