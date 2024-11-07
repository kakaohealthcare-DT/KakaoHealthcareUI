import UIKit
import AVKit
import AVFoundation
import os.log

public class PiPView: UIView {
	
	static public func isPiPSupported() -> Bool {
		return AVPictureInPictureController.isPictureInPictureSupported()
	}
	
	private var logger: Logger {
		os.Logger(subsystem: "UIExtension", category: "PipView")
	}
	
	public let pipBufferDisplayLayer = AVSampleBufferDisplayLayer()
	private lazy var pipController: AVPictureInPictureController? = {
		if PiPView.isPiPSupported() {
			let controller = AVPictureInPictureController(contentSource: .init(
				sampleBufferDisplayLayer: pipBufferDisplayLayer,
				playbackDelegate: self))
			controller.delegate = self
			return controller
		} else {
			return nil
		}
	}()
	
	private var pipPossibleObservation: NSKeyValueObservation?
	private var frameSizeObservation: NSKeyValueObservation?
	private var refreshIntervalTimer: Timer?
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}
	
	public func initialize() {
		guard PiPView.isPiPSupported() else { return }
		do {
			let session = AVAudioSession.sharedInstance()
			try session.setCategory(.playback, mode: .moviePlayback)
			try session.setActive(true)
		} catch let error {
			logger.error("\(#line) \(error)")
		}
		
	}
	
	public func startPictureInPicture(
		withRefreshInterval: TimeInterval = (0.1 / 60.0)
	) {
		setupVideoLayerView()
		DispatchQueue.main.async { [weak self] in
			self?.startPictureInPictureSub(refreshInterval: withRefreshInterval)
		}
	}
	
	private func startPictureInPictureSub(
		refreshInterval: TimeInterval?
	) {
		guard PiPView.isPiPSupported() else { return }
		
		render()
		guard let pipController = pipController else { return }
		if pipController.isPictureInPicturePossible {
			DispatchQueue.main.async { [weak self] in
				pipController.startPictureInPicture()
				if let refreshInterval {
					self?.setRenderInterval(refreshInterval)
				}
			}
			
		} else {
			/// It will take some time for PiP to become available.
			pipPossibleObservation = pipController.observe(
				\AVPictureInPictureController.isPictureInPicturePossible, options: [.initial, .new]
			) { [weak self] _, change in
					guard let self = self else { return }
					if let value = change.newValue, value {
						pipController.startPictureInPicture()
						self.pipPossibleObservation = nil
						if let ti = refreshInterval {
							self.setRenderInterval(ti)
					}
				}
			}
		}
	}
	
	private let videoLayerView = UIView()
	
	private func setupVideoLayerView() {
		guard videoLayerView.superview == nil else { return }
		
		self.addSubview(videoLayerView)
		self.sendSubviewToBack(videoLayerView)
		videoLayerView.frame = self.bounds
		videoLayerView.alpha = 0
		
		pipBufferDisplayLayer.frame = videoLayerView.bounds
		pipBufferDisplayLayer.videoGravity = .resizeAspect
		videoLayerView.layer.addSublayer(pipBufferDisplayLayer)
		
		frameSizeObservation = self.observe(\PiPView.frame, options: [.initial, .new]) { [weak self] _, _ in
			if let self {
				self.videoLayerView.frame = self.bounds
			}
		}
	}
	
	public func stopPictureInPicture() {
		guard let pipController = pipController else { return }
		if pipController.isPictureInPictureActive {
			pipController.stopPictureInPicture()
		}
		
		if refreshIntervalTimer != nil {
			refreshIntervalTimer?.invalidate()
			refreshIntervalTimer = nil
		}
	}
	
	public func isPictureInPictureActive() -> Bool {
		guard let pipController = pipController else { return false }
		return pipController.isPictureInPictureActive
	}
	
	/// Draws the current UIView state as a video.
	/// Note that the PiP image will not change unless this function is called.
	public func render() {
		/// Occasionally occurs in the background
		if pipBufferDisplayLayer.status == .failed {
			pipBufferDisplayLayer.flush()
		}
		guard let buffer = makeNextVieoBuffer() else { return }
		pipBufferDisplayLayer.enqueue(buffer)
	}
	
	public func setRenderInterval(
		_ interval: TimeInterval
	) {
		guard PiPView.isPiPSupported() else { return }
		
		refreshIntervalTimer = Timer(
			timeInterval: interval, repeats: true) { [weak self] _ in
				guard let self = self else { return }
				self.render()
		}
		if let refreshIntervalTimer {
			RunLoop.main.add(refreshIntervalTimer, forMode: .default)
		}
	}
	
	public func makeNextVieoBuffer() -> CMSampleBuffer? {
		self.makeSampleBuffer()
	}
}

extension PiPView: AVPictureInPictureControllerDelegate {
	public func pictureInPictureController(
		_ pictureInPictureController: AVPictureInPictureController,
		failedToStartPictureInPictureWithError error: Error
	) {
		logger.error("\(#line) \(error)")
	}
	
	public func pictureInPictureControllerWillStartPictureInPicture(
		_ pictureInPictureController: AVPictureInPictureController
	) {
	}
	
	public func pictureInPictureControllerWillStopPictureInPicture(
		_ pictureInPictureController: AVPictureInPictureController
	) {
		refreshIntervalTimer?.invalidate()
		refreshIntervalTimer = nil
	}
}

extension PiPView: AVPictureInPictureSampleBufferPlaybackDelegate {
	public func pictureInPictureController(
		_ pictureInPictureController: AVPictureInPictureController,
		setPlaying playing: Bool
	) {
	}
	
	public func pictureInPictureControllerTimeRangeForPlayback(
		_ pictureInPictureController: AVPictureInPictureController
	) -> CMTimeRange {
		.init(
			start: .zero,
			duration: .init(
				value: 3600 * 24,
				timescale: 1
			)
		)
	}
	
	public func pictureInPictureControllerIsPlaybackPaused(
		_ pictureInPictureController: AVPictureInPictureController
	) -> Bool {
		false
	}
	
	public func pictureInPictureController(
		_ pictureInPictureController: AVPictureInPictureController,
		didTransitionToRenderSize newRenderSize: CMVideoDimensions
	) {
	}
	
	public func pictureInPictureController(
		_ pictureInPictureController: AVPictureInPictureController,
		skipByInterval skipInterval: CMTime,
		completion completionHandler: @escaping () -> Void
	) {
		completionHandler()
	}
}
