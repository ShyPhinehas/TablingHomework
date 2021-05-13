
import UIKit

public let imageLoadQueueName : String = "imageLoadQueueName"
public typealias ImageloaderCompletedCallback = (_ image: UIImage?,_ error: Error?) -> ()

//이미지 다운로드 관장
class ImageCenter: NSObject {
    
    static let `default` = ImageCenter()

    //이미지 캐쉬관리
    private var imageCaches : NSCache = NSCache<AnyObject,AnyObject>()
    //오퍼래리션 관리
    private var loadOperations : NSCache = NSCache<AnyObject,AnyObject>()
    //오퍼레이션 생성
    public var imageLoadQueue : OperationQueue = {
        let ilq = OperationQueue()
        ilq.name = imageLoadQueueName
        ilq.maxConcurrentOperationCount = 1
        return ilq
    }()
    
    override init() {
        super.init()
        //메모리....부족 노티
        NotificationCenter.default.addObserver(self, selector: #selector(removeAllCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    //이미지 다운로드
    public func loadImage(urlStr: String, completedCallback: @escaping ImageloaderCompletedCallback) {
        
        if isExistOperation(key: urlStr){
            return
        }
        
        let down = ImageloaderOperation(urlStr: urlStr, completedCallback: completedCallback)
        self.saveOperation(down, key: urlStr)
        self.imageLoadQueue.addOperation(down)
    }
    
    //이미지 캐시 저장
    public func saveCache(_ image: UIImage, key: String) {
        imageCaches.setObject(image, forKey: key as AnyObject)
    }
    
    //캐시된 이미지
    public func savedCache(key: String) -> UIImage? {
        return imageCaches.object(forKey: key as AnyObject) as? UIImage
    }
    
    //오퍼레이션 저장...
    public func saveOperation(_ op: ImageloaderOperation, key: String) {
        loadOperations.setObject(op, forKey: key as AnyObject)
    }
    
    //오퍼레이션 삭제
    public func removeOperation(key: String){
        if isExistOperation(key: key){
            loadOperations.removeObject(forKey: key as AnyObject)
        }
    }
    //오페레이션?
    private func isExistOperation(key: String) -> Bool{
        if let _ = loadOperations.object(forKey: key as AnyObject){
            return true
        }
        return false
    }
    //모든 캐시 삭제
    @objc private func removeAllCache(){
        self.imageCaches.removeAllObjects()
    }

}

public class ImageloaderOperation: Operation {

    let urlStr : String
    var completedCallback : ImageloaderCompletedCallback?
    
    init(urlStr: String, completedCallback: @escaping ImageloaderCompletedCallback) {
        self.urlStr = urlStr
        self.completedCallback = completedCallback
    }
    
    override public func main() {
        
        if self.isCancelled {
            return
        }

        let ifm = ImageFileManager()
        var error: Error?
        
        
        let image : UIImage? = {
            
            if let imageCache = ImageCenter.default.savedCache(key: urlStr){                        // image in cache
                return imageCache
            
            }else if ifm.isExistCacheFile(urlStr: urlStr){                                          // image in file
                let image = UIImage(contentsOfFile: ifm.imageFilePath(urlStr: urlStr)!.path)
                ImageCenter.default.saveCache(image!, key: urlStr)
                return image
            }else{                                                                                  // image in url
                do {
                    
                    let url = try urlStr.asURL()
                    let data = try Data(contentsOf: url)
                    
                    let imageFromData = UIImage(data: data)
                    
                    if  let _ = imageFromData, let folderUrl = ifm.imageFilePath(urlStr: urlStr){
                        try imageFromData!.pngData()?.write(to: folderUrl)
                        ImageCenter.default.saveCache(imageFromData!, key: urlStr)
                    }
                    
                    return imageFromData
                    
                }catch let e{
                    error = e
                }
                
                return nil
            }
        }()
        
        ImageCenter.default.removeOperation(key: urlStr)
        
        DispatchQueue.main.async {
            self.completedCallback?(image,error)
        }
    }
}

extension UIImageView{
    
    @objc public func ic_image(urlStr: String?, completed: (()->())? = nil) {
        
        guard
            let us = urlStr
        else {
            completed?()
            return
        }
        
        ImageCenter.default.loadImage(urlStr: us) { (image, error) in
            self.image = image
            completed?()
        }
    }
    
    
}

