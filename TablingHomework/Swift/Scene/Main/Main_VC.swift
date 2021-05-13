//
//  ViewController.swift
//  TablingHomework
//
//  Created by LittleFox iOS Developer MacBook on 2021/05/11.
//

import UIKit
import RxCocoa
import RxSwift

class Main_VC: UIViewController {
    
    private let vm = Main_VM()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColectionView()
    }
    
    private func setupColectionView(){
        self.bindToCells()
        self.bindTouchEvent()
    }
    
    private func bindToCells(){
        self.vm.loadImageData { (imageInfos, errorMessage) in
            if let em = errorMessage{
                //show alerts
            }else{
                imageInfos.bind(to: self.collectionView.rx.items(cellIdentifier: "MainCollecotionViewCell", cellType: MainCollecotionViewCell.self)) {index,element,cell in
                    let imageurl = element.download_urlstr.size(.custum(width: 100))
                    cell.image?.ic_image(urlStr: imageurl)
                }.disposed(by: self.disposeBag)
            }
        }
    }
    
    private func bindTouchEvent(){
        self.collectionView.rx
            .modelSelected(ImageInfo.self)
            .subscribe({ imageimfo in
                guard
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "Image_VC") as? Image_VC
                else{
                    return
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
                detailVC.vm.picImageName.value = imageimfo.element?.download_urlstr.size(.origin)
        }).disposed(by: self.disposeBag)
    }
}

