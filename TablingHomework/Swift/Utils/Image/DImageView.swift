//
//  DImageView.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/13.
//

import UIKit

class DImageView: UIImageView{
    private  var indicate: UIActivityIndicatorView?
    var isShowIndicated: Bool = false{
        didSet{
            if self.isShowIndicated{
                self.makeIndicate()
            }else{
                self.removeIndicate()
            }
        }
    }
    
    private func makeIndicate(){
        
        self.removeIndicate()
        
        self.indicate = UIActivityIndicatorView(style: .whiteLarge)
        self.indicate?.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addSubview(self.indicate!)
        
        self.indicate?.startAnimating()
    }
    
    
    private func removeIndicate(){
        self.indicate?.removeFromSuperview()
        self.indicate = nil
    }
    
    
    override func ic_image(urlStr: String?, completed: (() -> ())? = nil) {
        guard
            let us = urlStr
        else {
            completed?()
            return
        }
        
        self.isShowIndicated = true
        ImageCenter.default.loadImage(urlStr: us) { (image, error) in
            self.isShowIndicated = false
            self.image = image
            completed?()
        }
    }
}
