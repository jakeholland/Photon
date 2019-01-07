import AppKit
import AVFoundation
import ImageIO

enum ConvertGif {
    
    static func convert(_ filename: String, framerate: Int = 10, completion: @escaping () -> Void) {
        let sourceUrl = URL(fileURLWithPath: filename.mov)
        let destinationUrl = URL(fileURLWithPath: filename.gif) as CFURL
        let video = AVURLAsset(url: sourceUrl, options: nil)
        let times = frameTimes(for: video, framerate: 10)
        
        guard let destination = CGImageDestinationCreateWithURL(destinationUrl, kUTTypeGIF, times.count, nil) else { return }
        
        let generator = AVAssetImageGenerator(asset: video)
    
        let tolerance = CMTimeMakeWithSeconds(0.01, preferredTimescale: 600)
        generator.requestedTimeToleranceBefore = tolerance
        generator.requestedTimeToleranceAfter = tolerance
 
        generator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
            guard let imageRef = image else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            CGImageDestinationAddImage(destination, imageRef, nil)
            
            if requestedTime == times.last?.timeValue {
                CGImageDestinationFinalize(destination)
                completion()
            }
        }
    }
    
    private static func frameTimes(for video: AVAsset, framerate: Int = 10) -> [NSValue] {
        let duration = Float(video.duration.value) / Float(video.duration.timescale)
        let frameCount = Int(duration) * framerate
        let interval = duration / Float(frameCount)
        
        var times: [NSValue] = []
        for frameNumber in 0 ..< frameCount {
            let time = CMTimeMakeWithSeconds(Float64(interval) * Float64(frameNumber), preferredTimescale: 600)
            times.append(NSValue(time: time))
        }
        
        return times
    }
}
