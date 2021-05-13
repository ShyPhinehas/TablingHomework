
import Foundation

class DataDelegate: NSObject, URLSessionDataDelegate{
        
    private var _data: Data = Data()
    var completedColoser: ((_ data: Data?)->())?

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        var credential: URLCredential?
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            if let serverTrust = challenge.protectionSpace.serverTrust{
                credential = URLCredential(trust: serverTrust)
                if let _ = credential{
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                }
            }
        }else{
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        completionHandler(disposition,credential)
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession){
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        self._data.append(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        DispatchQueue.main.async {
            self.completedColoser?(self._data)
        }
    }
    
    public func clearData() {
        self._data.removeAll()
    }
}
