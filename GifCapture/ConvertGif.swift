import AppKit
import AVFoundation
import ImageIO

enum ConvertGif {
    
    static func convert(_ filepath: String, framerate: Int = 10, completion: @escaping () -> Void) {
        let sourceUrl = URL(fileURLWithPath: filepath)
        let destinationUrl = URL(fileURLWithPath: filepath.gif)
        let video = AVURLAsset(url: sourceUrl, options: nil)
        let times = frameTimes(for: video, framerate: 10)
        
        guard let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, kUTTypeGIF, times.count, nil) else { return }
        
        let generator = AVAssetImageGenerator(asset: video)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero

        generator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }

            guard let image = image else { return }
            
            CGImageDestinationAddImage(destination, image, nil)
            
            if requestedTime == times.last?.timeValue {
                CGImageDestinationFinalize(destination)
                completion()
            }
        }
    }
    
    private static func frameTimes(for video: AVAsset, framerate: Int = 10) -> [NSValue] {
        let duration = Float(video.duration.value) / Float(video.duration.timescale)
        let frameCount = Int(duration * Float(framerate))
        
        var times: [NSValue] = []
        for frameNumber in 0 ..< frameCount {
            let time = CMTime(value: CMTimeValue(frameNumber), timescale: CMTimeScale(framerate))
            times.append(NSValue(time: time))
        }
        
        return times
    }

}
