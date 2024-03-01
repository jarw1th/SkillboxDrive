import UIKit

class SkillboxActivityIndicator: UIView {
    // MARK: Variables
    lazy private var animationLayer: CALayer = {
        return CALayer()
    }()
    
    var isAnimating: Bool = false
    var hidesWhenStopped: Bool = true
    
    // MARK: Initialization
    init(_ image: UIImage) {
        let frame: CGRect = CGRectMake(-12, -12, 24, 24)
        
        super.init(frame: frame)
        
        animationLayer.frame = frame
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        
        self.layer.addSublayer(animationLayer)
        
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    func startAnimating () {
        
        if isAnimating {
            return
        }
        
        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }

    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(layer: animationLayer)
    }
    
    // MARK: Private Functions
    private func addRotation(forLayer layer: CALayer) {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = .forwards
        rotation.fromValue = NSNumber(floatLiteral: 0.0)
        rotation.toValue = NSNumber(floatLiteral: 3.14 * 2.0)
        
        layer.add(rotation, forKey: "rotate")
    }

    private func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        isAnimating = false
    }

    private func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
    }


}
