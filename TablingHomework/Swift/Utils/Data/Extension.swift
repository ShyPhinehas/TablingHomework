
import Foundation

extension URLRequest {
    init(url: URL, method: HTTPMethod, headers: HTTPHeaders? = nil) {

        self.init(url: url)
        httpMethod = method.rawValue
        if let _ = headers{
            for(key,value) in headers!{
                setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}

public enum DataConetedError: Error{
    case invalidURL(url: URL_C)
}

public protocol URL_C {
    func asURL() throws -> URL
}

extension String: URL_C {
    public func asURL() throws -> URL {
        guard let url = URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            throw DataConetedError.invalidURL(url: self)
        }
        return url
    }
}
