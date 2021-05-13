
import UIKit

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

class DataCenter: NSObject{

    static let shared = DataCenter()
    private var delegate : DataDelegate!
    
    lazy var session : URLSession = {
        self.delegate = DataDelegate()
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: nil)
    }()

    func request(_ urlStr: String, method: HTTPMethod = .get,headers: HTTPHeaders? = nil) -> Result{
//        let url = try! urlStr.asURL()
        let urlRequest: URLRequest = URLRequest(url: URL(string: urlStr)!, method: method, headers: headers)
        let task = session.dataTask(with: urlRequest)
        let result = Result(task: task, delegate: self.delegate)
        return result
    }

}

extension DataCenter {
    func request(api: Api) -> Result {
        return self.request(api.address, method: api.method)
    }
}
