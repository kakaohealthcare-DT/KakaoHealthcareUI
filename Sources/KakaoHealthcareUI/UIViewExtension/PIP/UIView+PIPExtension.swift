import UIKit
import Foundation
import AVKit
import AVFoundation

public extension UIView {
	func makeSampleBuffer() -> CMSampleBuffer? {
		let scale = UIScreen.main.scale
		let size = CGSize(
			width: (bounds.width * scale),
			height: (bounds.height * scale))
		var pixelBuffer: CVPixelBuffer?
		var status: CVReturn?
		if let kcfBoolTrue = kCFBooleanTrue {
			status = CVPixelBufferCreate(
				kCFAllocatorDefault,
				Int(size.width),
				Int(size.height),
				kCVPixelFormatType_32ARGB,
				[
					kCVPixelBufferCGImageCompatibilityKey: kcfBoolTrue,
					kCVPixelBufferCGBitmapContextCompatibilityKey: kcfBoolTrue,
					kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary
				] as CFDictionary, &pixelBuffer
			)
		}
		
		if status != kCVReturnSuccess {
			return nil
		}
		
		guard let pixelBuffer else { return nil }
		
		CVPixelBufferLockBaseAddress(pixelBuffer, [])
		defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
		
		guard let context = CGContext(
			data: CVPixelBufferGetBaseAddress(pixelBuffer),
			width: Int(size.width),
			height: Int(size.height),
			bitsPerComponent: 8,
			bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
			space: CGColorSpaceCreateDeviceRGB(),
			bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else { return nil }
		
		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: scale, y: -scale)
		layer.render(in: context)
		
		var formatDescription: CMFormatDescription?
		status = CMVideoFormatDescriptionCreateForImageBuffer(
			allocator: kCFAllocatorDefault,
			imageBuffer: pixelBuffer,
			formatDescriptionOut: &formatDescription)
		
		if status != kCVReturnSuccess {
			return nil
		}
		
		/// 시간대 조정 필요
		let now = CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 60)
		let timingInfo = CMSampleTimingInfo(
			duration: .init(seconds: 1, preferredTimescale: 60),
			presentationTimeStamp: now,
			decodeTimeStamp: now)
		
		do {
			guard let formatDescription else { return nil }
			return try CMSampleBuffer(
				imageBuffer: pixelBuffer,
				formatDescription: formatDescription,
				sampleTiming: timingInfo)
		} catch {
			return nil
		}
	}
}
