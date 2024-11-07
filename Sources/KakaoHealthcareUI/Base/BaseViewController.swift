import UIKit
import KakaoHealthcareFoundation

open class BaseViewController: UIViewController {
  
  deinit {
    Logger.debug("\(Self.self)")
  }
	
	public override init(
		nibName nibNameOrNil: String?,
		bundle nibBundleOrNil: Bundle?
	) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setUserInterface()
	}
	
	public required init?(coder: NSCoder) {
		fatalError("user designed initializer")
	}
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavgationBar()
    bind()
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateNavgationBar()
  }
  
  open func setUserInterface() {}
  open func bind() {}
  
  open func setupNavgationBar() { }
  
  open func updateNavgationBar() {
  }
}
