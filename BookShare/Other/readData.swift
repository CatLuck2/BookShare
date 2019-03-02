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
        let childString = userDataClass.userDataID
        print(childString)
        self.storageref.child("User").child(childString).downloadURL(completion: { (url, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.userDataClass.iconMetaData = url!.absoluteString
            }
        })
    }
    
    //ユーザーデータを取得する
    func readMyData() {
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
                            self.userDataClass.myItemID = data.data()[key]! as! [String]
                        default:
                            break
                        }
                    }
                }
                //取得したUserDataIDでアイコンURLを取得
                self.readMyIcon()
            }
        }
    }
    
    
    
    //自分が出品した本のデータを取得
    func readMyItemData(collectionView1:UICollectionView) {
        //データの総数
        var amountOfData = 0
        //1データ内のループ数
        var amountOfloop = 0
        //取得するデータの数だけUserData - allItemsを初期化する
        self.userDataClass.myItems = [[String:[String : String]]](repeating: ["0":["":""],"1":["":""],"2":["":""],"3":["":""],"4":["":""]], count: self.userDataClass.myItemID.count)
        //本のデータを取得
        self.db.collection("Item").getDocuments { (snapdata, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //                print(self.userDataClass.itemID)
                //データを順に取り出していく
                for data in snapdata!.documents{
                    for key in data.data().keys {
                        //myItemIDに該当するかどうかを診断
                        for i in 0...self.userDataClass.myItemID.count-1 {
                            //もし自分の本のデータと一致すれば、myItemsに入れる
                            if self.userDataClass.myItemID[i] == data.documentID {
                                self.userDataClass.myItems[amountOfData][key] = data.data()[key]! as! [String : String]
                            }
                        }
                        amountOfloop += 1
                    }
                    amountOfloop = 0
                    amountOfData += 1
                    //自分の本のデータを全て取得し終えたら、画像を取得開始
                    if amountOfData == self.userDataClass.myItemID.count {
                        self.readMyItemImage(collectionView2:collectionView1)
                    }
                }
                
            }
        }
    }
    
    //自分が出品した本の画像を取得
    func readMyItemImage(collectionView2:UICollectionView) {
        //階層を指定する際の文字列
        var childString = ""
        //本の画像を取得していく
        for i in 0...self.userDataClass.myItemID.count-1 {
            //itemIDをchildStringに入れていく
            childString = self.userDataClass.myItemID[i]
            //取得開始
            self.storageref.child("Item").child(childString).downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error getting downloadURL: \(err)")
                } else {
                    //                    print("\(self.userDataClass.itemID[i]) " + url!.absoluteString)
                    //ダウンロードURLを入れる
                    self.userDataClass.myItemURL.append(url!)
                    //もし全てのダウンロードURLを取得したら、collectionViewをリロード
                    if self.userDataClass.myItemID.count == self.userDataClass.myItemURL.count {
                        collectionView2.reloadData()
                        //                        print(self.userDataClass.itemID)
                        //                        print(self.userDataClass.itemURL)
                    } else {
                    }
                }
            })
        }
    }
    
    
    //全ての本のIDを取得
    func readAllItemID(collectionView1:UICollectionView) {
        //取得開始
        db.collection("Item").getDocuments { (snapdata, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for data in snapdata!.documents {
                    //Item階層の各ドキュメントIDを取得
                    self.userDataClass.allItemID.append(data.documentID)
                }
                print(self.userDataClass.allItemID)
                self.readAllItemData(collectionView2: collectionView1)
            }
        }
    }
    
    //全ての本のデータを読み込む
    func readAllItemData(collectionView2:UICollectionView) {
        //データの総数
        var amountOfData = 0
        //allitemIDの数だけallitemsを初期化
        self.userDataClass.allItems = [[String:[String : String]]](repeating: ["0":["":""],"1":["":""],"2":["":""],"3":["":""],"4":["":""]], count: self.userDataClass.allItemID.count)
        //本のデータを取得
        self.db.collection("Item").getDocuments { (snapdata, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //                print(self.userDataClass.itemID)
                //データを順に取り出していく
                for data in snapdata!.documents{
                    for key in data.data().keys {
                        self.userDataClass.allItems[amountOfData][key] = data.data()[key]! as! [String : String]
                    }
                    amountOfData += 1
                }
                self.readAllItemImage(collectionView3: collectionView2)
            }
        }
    }
    
    //全ての本の画像を読み込む
    func readAllItemImage(collectionView3:UICollectionView) {
        //階層を指定する際の文字列
        var childString = ""
        //ItemIDを１つ以上取得できたかどうか
        if self.userDataClass.allItemID.count < 1 {
            return
        } else {
            //本の画像を取得していく
            for i in 0...self.userDataClass.allItemID.count-1 {
                //itemIDをchildStringに入れていく
                childString = self.userDataClass.allItemID[i]
                //取得開始
                self.storageref.child("Item").child(childString).downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Error getting downloadURL: \(err)")
                    } else {
                        //ダウンロードURLを入れる
                        self.userDataClass.allItemURL.append(url!)
                        //もし全てのダウンロードURLを取得したら、collectionViewをリロード
                        if self.userDataClass.allItemID.count == self.userDataClass.allItemURL.count {
                            collectionView3.reloadData()
                        } else {
                        }
                    }
                })
            }
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
