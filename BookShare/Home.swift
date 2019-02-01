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

class Home: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Firebaseから取得したItemIDを格納する
    var photos = [String]()
    //photosの長さを保持
    var photosCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        downloadImageData()
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
        //画像をセット
        imageView.sd_setImage(with: storageref)
        if self.photosCount - 1 == indexPath.row {
            self.photos = [String]()
            self.photosCount = Int()
        }
        return cell
    }
    
    //FirebaseからItemのURLを取得する
    func downloadImageData() {
        let ref = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
        self.photos = [String]()
        ref.child("Item").observe(.value) { (snap) in
            for item in snap.children {
                let snapdata = item as! DataSnapshot
                let item = snapdata.value as! [[String:String]]
                print("----")
                print(item[0]["ItemID"]!)
                self.photos.append(item[0]["ItemID"]!)
                print("-------")
                print(1111)
                print(self.photos)
            }
            self.photosCount = self.photos.count
            self.collectionView.reloadData()
        }
//        ref.child("Item").observeSingleEvent(of: .value) { (snap, error) in
//
//
//        }
    }

}

/*
 
 [["Status": "display", "UserID": "userID", "Title": "gfdsf",
 "DeliveryBurden": "着払い(受取人)", "Date": "2019/02/01 12:17:34",
 "ItemID": "hTykeCfet", "State": "ボロボロ", "Category": "スポーツ",
 "UserName": "userName", "DeliveryDay": "5~6日", "DeliveryWay": "普通郵便", "Good": "0"],
 ["?": "?"],
 ["?": "?"],
 ["?": "?"],
 ["?": "?"]]
 
 */
