//
//  Image_VC.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/12.
//

import UIKit

class Image_VC: UIViewController {
    
    private let vm = Image_VM()
    
    @IBOutlet weak var picture: DImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.picImageName.bind { [weak self] imageName in
            self?.picture.ic_image(urlStr: imageName)
        }
    }
}
