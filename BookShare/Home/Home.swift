//
//  Home.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage

class Home: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Firebaseから取得したItemIDを格納する
    var photos = [String]()
    //cellForItemAtが実行されたカウント
    var count_cellfunc = 0
    
    @IBOutlet weak var sc: UIScrollView!
    
    //スクロールビューに配置するView
    var vc = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //vcのframe
        vc.frame = CGRect(x: 0, y: 0, width: 600, height: 55)
        //上部のスクロールビューに多数のボタンを配置
        for i in 0...6 {
            let button = UIButton()
            //サイズ
            button.frame = CGRect(x: (i*80), y: 0, width: 90, height: 55)
            //タグ
            button.tag = i
            //buttonに文字を挿入
            setTitleForButton(tag: button.tag, button: button)
            //button.titleの色
            button.setTitleColor(.black, for: .normal)
            //buttonに処理を追加
//            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
            //vcに載せる
            vc.addSubview(button)
        }
        
        //スクロールビューにvcを配置
        sc.addSubview(vc)
        sc.contentSize = vc.bounds.size

        collectionView.delegate = self
        collectionView.dataSource = self
        
        //ユーザーデータを取得
//        let readD = readData()
//        readD.readMyData()
        //本のデータを取得
//        downloadImageData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //imageViewを宣言
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("userID").child("Item").child(photos[indexPath.row])
        imageView.sd_setImage(with: storageref)
        return cell
    }
    
    //スクロールビューのボタンに文字を入れる
    func setTitleForButton(tag:Int, button:UIButton){
        switch tag {
        case 0:
            button.setTitle("最新", for: .normal)
        case 1:
            button.setTitle("人気", for: .normal)
        case 2:
            button.setTitle("フォロー", for: .normal)
        case 3:
            button.setTitle("文学", for: .normal)
        case 4:
            button.setTitle("社会", for: .normal)
        case 5:
            button.setTitle("科学", for: .normal)
        case 6:
            button.setTitle("ビジネス", for: .normal)
        default:
            break
        }
    }
    
    //FirebaseからItemのURLを取得する
    func downloadImageData() {
        let ref = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
        self.photos = [String]()
        ref.child("Item").observe(.value) { (snap) in
            for item in snap.children {
                let snapdata = item as! DataSnapshot
                //１つのデータ
                let item = snapdata.value as! [[String:String]]
                self.photos.append(item[0]["ItemID"]!)
            }
//            self.photosCount = self.photos.count
            self.collectionView.reloadData()
        }
    }
    
    //ログアウト
    @IBAction func signout(_ sender: Any) {
        let menu = Menu()
        self.present(menu.menuAlert(), animated: true, completion: nil)
    }

}

