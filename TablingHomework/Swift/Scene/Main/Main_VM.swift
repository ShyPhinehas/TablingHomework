//
//  Main_VM.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/11.
//

import Foundation
import RxSwift

typealias ShowAlerts = (is: Bool, title: String, desc: String)

class Main_VM {
    
    var imageinfos: Box<[ImageInfo]?> = Box(nil)
    var isShowAlerts: Box<ShowAlerts> = Box((false,"",""))
    
    func loadImageData(){
        DataCenter.shared.request(api: .image_list).toValue(type: [ImageInfo].self) { res in
            if let em = res.serverReturn.errorMessage{
                self.isShowAlerts.value = (true,"",em)
            }else{
                self.imageinfos.value = res.data!
            }
        }
    }
}
