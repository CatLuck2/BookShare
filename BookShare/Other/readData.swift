//
//  readData.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/17.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//
//        DispatchQueue.main.async {
//
//        }


import UIKit
import Firebase

class readData: UIViewController {

    //FireStore
    let db = Firestore.firestore()
    //Storageパス
    let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com")
    //UserDataClass
    var userDataClass = UserData.userClass
    
    //ユーザーアイコンを取得
    func readMyIcon() {
        self.storageref.child("User").child("Icon").downloadURL(completion: { (url, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.userDataClass.iconMetaData = url!.absoluteString
            }
        })
    }
    
    //ユーザーデータを読み込む
    func readMyData(collectionView1:UICollectionView) {
        //ユーザーデータ
        self.db.collection("User").getDocuments() { (snapdata, err) in
            //エラー処理
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //データを順に取り出していく
                for data in snapdata!.documents{
                    for key in data.data().keys {
                        switch key {
                        case "UserName":
                            self.userDataClass.userName = data.data()[key]! as! String
                        case "UserID":
                            self.userDataClass.userID = data.data()[key]! as! String
                        case "UserDataID":
                            self.userDataClass.userDataID = data.data()[key]! as! String
                        case "Follow":
                            self.userDataClass.follow = data.data()[key]! as! String
                        case "Follower":
                            self.userDataClass.follower = data.data()[key]! as! String
                        case "Good":
                            self.userDataClass.good = data.data()[key]! as! String
                        case "Share":
                            self.userDataClass.share = data.data()[key]! as! String
                        case "Get":
                            self.userDataClass.get = data.data()[key]! as! String
                        case "Profile":
                            self.userDataClass.profile = data.data()[key]! as! String
                        case "Item":
                            self.userDataClass.itemID = data.data()[key]! as! [String]
                        default:
                            break
                        }
                    }
                }
                //本のデータを取得
                self.readItemData(collectionView2:collectionView1)
            }
        }
    }
    
    //自分が出品した本のデータを取得
    func readMyItemData() {
        
    }
    
    //自分が出品した本の画像を取得
    func readMyItemImage() {
        
    }
    
    
    //全ての本のIDを取得
    func readAllItemID() {
        
    }
    
    //全ての本のデータを読み込む
    func readItemData(collectionView2:UICollectionView) {
        //データの総数
        var amountOfData = 0
        //1データ内のループ数
        var amountOfloop = 0
        //本のデータを取得
        self.db.collection("Item").getDocuments { (snapdata, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                print(self.userDataClass.itemID)
                //取得するデータの数だけUserData - allItemsを初期化する
                self.userDataClass.allItems = [[String:[String : String]]](repeating: ["0":["":""],"1":["":""],"2":["":""],"3":["":""],"4":["":""]], count: snapdata!.count)
                //データを順に取り出していく
                for data in snapdata!.documents{
                    for key in data.data().keys {
                        self.userDataClass.allItems[amountOfData][key] = data.data()[key]! as! [String : String]
                        amountOfloop += 1
                    }
                    amountOfloop = 0
                    amountOfData += 1
                    if amountOfData == self.userDataClass.itemID.count {
                        self.readItemImage(collectionView3:collectionView2)
                    }
                }
                
            }
        }
    }
    
    //全ての本の画像を読み込む
    func readItemImage(collectionView3:UICollectionView) {
        var childString = ""
        //ユーザーデータ
        for i in 0...self.userDataClass.itemID.count-1 {
            childString = self.userDataClass.itemID[i]
            self.storageref.child("Item").child(childString).downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error getting downloadURL: \(err)")
                } else {
//                    print("\(self.userDataClass.itemID[i]) " + url!.absoluteString)
                    //ダウンロードURLを入れる
                    self.userDataClass.itemURL.append(url!)
                    //もし全てのダウンロードURLを取得したら、collectionViewをリロード
                    if self.userDataClass.itemID.count == self.userDataClass.itemURL.count {
                        collectionView3.reloadData()
//                        print(self.userDataClass.itemID)
//                        print(self.userDataClass.itemURL)
                    } else {
                    }
                }
            })
        }
    }

}

//extension DispatchQueue {
//    class func mainSyncSafe(execute work: () -> Void) {
//        if Thread.isMainThread {
//            work()
//        } else {
//            DispatchQueue.main.sync(execute: work)
//        }
//    }
//
//    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
//        if Thread.isMainThread {
//            return try work()
//        } else {
//            return try DispatchQueue.main.sync(execute: work)
//        }
//    }
//}
