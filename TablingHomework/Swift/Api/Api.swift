//
//  Api.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/12.
//

import Foundation

public enum Api {
    case image_list
    
    var version: Int {
        switch self {
        default :
            return 2
        }
    }

    var key: String{
        switch self {
        case .image_list:
            return "list"
        }
    }
    
    var address: String {
        "https://picsum.photos/v\(self.version)/" + self.key
    }
    
    var method: HTTPMethod{
        switch self {
        case .image_list:
            return .get
        }
    }
    
    var parameters: Parameters?{
        switch self {
        default:
            return nil
        }
    }

}
