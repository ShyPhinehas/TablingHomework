//
//  model.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/12.
//

import UIKit

enum DImgaeSize {
    case custum(width: CGFloat)
    case origin
}

struct DImageStr {
    let urlStr: String
    let size: CGSize
    
    func size(_ s: DImgaeSize) -> String {
 
        switch s {
        case .custum(let width):
            
            let strings = self.urlStr.split(separator: "/")
            
            let w: CGFloat = width
            let h: CGFloat = w*CGFloat(size.height/size.width)
            
            return self.urlStr.replacingOccurrences(of: strings.last!, with: "\(Int(h))").replacingOccurrences(of: strings[strings.count-2], with: "\(Int(w))")
            
        case .origin:
            return self.urlStr
        }
    }
}

struct ImageInfo: Decodable {
    let id: String
    let author: String
    let urlstr: String
    let download_urlstr: DImageStr
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case download_url
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decode(String.self, forKey: .author)
        
        
        let width = try container.decode(Int.self, forKey: .width)
        let height = try container.decode(Int.self, forKey: .height)
        
        let size = CGSize(width: width, height: height)
        
        self.urlstr = try container.decode(String.self, forKey: .url)
        let du = try container.decode(String.self, forKey: .download_url)
        self.download_urlstr = DImageStr(urlStr: du, size: size)
    }
}
