//
//  Main_VM.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/11.
//

import Foundation
import RxSwift

class Main_VM {
    func loadImageData(call: @escaping (Observable<[ImageInfo]>, String?)->()){
        DataCenter.shared.request(api: .image_list).toValue(type: [ImageInfo].self) { res in
            if let em = res.serverReturn.errorMessage{
                call(Observable.empty(), em)
            }else{
                call(Observable.of(res.data!), nil)
            }
        }
    }
}
