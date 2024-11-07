import Foundation
import Network

final public class NetworkMonitor: ObservableObject {
	public static let shared = NetworkMonitor()
	
	private let queue = DispatchQueue.global()
	private let monitor: NWPathMonitor = NWPathMonitor()
	
	@Published
	public private(set) var isConnected: Bool = false
	@Published
	public private(set) var connectionType: ConnectionType = .unknown
	
	/// 연결타입
	public enum ConnectionType {
		case wifi
		case cellular
		case ethernet
		case unknown
	}
	
	public init() {
		startMonitoring()
	}
	
	public func startMonitoring() {
		monitor.start(queue: queue)
		monitor.pathUpdateHandler = { [weak self] path in
			self?.isConnected = path.status == .satisfied
			self?.getConenctionType(path)
		}
	}
	
	public func stopMonitoring() {
		monitor.cancel()
	}
	
	private func getConenctionType(_ path: NWPath) {
		if path.usesInterfaceType(.wifi) {
			connectionType = .wifi
		} else if path.usesInterfaceType(.cellular) {
			connectionType = .cellular
		} else if path.usesInterfaceType(.wiredEthernet) {
			connectionType = .ethernet
		} else {
			connectionType = .unknown
		}
	}
}
