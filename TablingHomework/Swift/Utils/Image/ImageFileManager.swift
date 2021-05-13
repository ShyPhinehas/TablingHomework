
import Foundation
import CommonCrypto

class ImageFileManager: NSObject {
    
    private var cacheFolder: URL? = {
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{
            let bundleID = (Bundle.main.bundleIdentifier ?? "") + "-imageCache"
            let path = cacheDir.appendingPathComponent(bundleID)
            
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            
            return path
        }
        
        return nil
    }()

    func isExistCacheFile(urlStr: String) -> Bool {
        if let filePath = imageFilePath(urlStr: urlStr){
            return FileManager.default.fileExists(atPath: filePath.path)
        }
        return false
    }
    
    func imageFilePath(urlStr: String) -> URL? {
        let fileName = urlStr.md5 + ".png"
        return cacheFolder?.appendingPathComponent(fileName)
    }
}

extension String {
    var md5: String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }

        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
