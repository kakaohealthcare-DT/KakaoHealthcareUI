import UIKit
import KakaoHealthcareFoundation

open class DTBaseNavigationController: UINavigationController {
    deinit {
        Logger.debug("\(Self.self)")
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
