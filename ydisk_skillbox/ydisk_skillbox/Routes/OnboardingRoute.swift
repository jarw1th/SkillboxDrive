import Foundation

protocol OnboardingRoute {
    func pushNextScreen( fromId: Int, toId: Int)
}

extension OnboardingRoute where Self: Router {
    func pushNextScreen(with transition: Transition, fromId: Int, toId: Int) {
        let vcList = [FirstOnboardingViewController(),
                                  SecondOnboardingViewController(),
                                  ThirdOnboardingViewController()
                                  /*, LoginViewController()*/]
        let router = DefaultRouter(rootTranstion: transition)
        router.root = vcList[fromId]
        
        route(to: vcList[toId], as: transition)
    }
    
    func pushNextScreen(fromId: Int, toId: Int) {
        pushNextScreen(with: PushTransition(), fromId: fromId, toId: toId)
    }
}

extension DefaultRouter: OnboardingRoute {}
