
import Foundation

enum ServerReturn {
    case ok
    case error(message: String)
    
    var errorMessage: String?{
        switch self {
        case .error(let message):
            return message
        default:
            return nil
        }
    }
}

struct Response<T:Decodable> {
    let serverReturn: ServerReturn
    let data: T?
}

class Result: NSObject{

    private var delegate : DataDelegate!
    private var task : URLSessionDataTask!
    
    init(task: URLSessionDataTask, delegate: DataDelegate) {
        super.init()
        
        self.task = task
        self.delegate = delegate
        
    }
    
    func resume() {
        self.task.resume()
    }
    
    func string(completed: @escaping (String?)->Void) {
        self.delegate.clearData()
        self.resume()
        self.delegate.completedColoser = {data in
            if let d = data{
                let str = String(data: d, encoding: String.Encoding.utf8)
                completed(str)
            }else{
                completed(nil)
            }
            
        }
    }
    
    func json(completed: @escaping (Any?)->Void) {
        self.delegate.clearData()
        self.resume()
        self.delegate.completedColoser = {data in
            if let d = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: d)
                    completed(json)
                }catch{
                    completed(nil)
                }
            }else{
                completed(nil)
            }
        }
    }
    
    func toValue<T: Decodable>(type: T.Type, completed: @escaping (Response<T>)->Void){
        self.delegate.clearData()
        self.resume()
        self.delegate.completedColoser = {data in
            if let d = data{
                let v = self.decode(type: T.self, jsonObject: d)
                if let errorMessage = v.errorMessage {
                    completed(Response<T>(serverReturn: .error(message: errorMessage), data: nil))
                }else{
                    completed(Response<T>(serverReturn: .ok, data: v.data))
                }
            }else{
                completed(Response<T>(serverReturn: .error(message: self.task.error?.localizedDescription ?? "unknown error"), data: nil))
            }
        }
    }
    
    private func decode<T: Decodable>(type: T.Type, jsonObject: Data) -> (data: T?, errorMessage: String?)  {
        let decoder  = JSONDecoder()
        do {
            let data = try decoder.decode(T.self, from: jsonObject)
            return (data, nil)
        }catch let e{
            print("decode error \(e.localizedDescription) ")
            return (nil, e.localizedDescription)
        }
    }
}
