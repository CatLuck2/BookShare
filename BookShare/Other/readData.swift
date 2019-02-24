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
//    let readD = readData()
    
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
                            self.userDataClass.item = data.data()[key]! as! [String]
                        default:
                            break
                        }
                    }
                }
                //本の画像URLを取得
                self.readItemData(collectionView2:collectionView1)
            }
        }
    }
    
    //ユーザーアイコン
    func readMyIcon() {
        self.storageref.child("User").child("Icon").downloadURL(completion: { (url, err) in
            if let err = err {
                print("fail")
            } else {
                self.userDataClass.iconMetaData = url!.absoluteString
            }
        })
    }
    
    //本のデータを読み込む
    func readItemData(collectionView2:UICollectionView) {
        var childString = ""
        //ユーザーデータ
        for i in 0...self.userDataClass.item.count-1 {
            childString = self.userDataClass.item[i]
            self.storageref.child("Item").child(childString).downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Fail")
                } else {
                    self.userDataClass.itemURL.append(url!)
                    if self.userDataClass.item.count == self.userDataClass.itemURL.count {
                        collectionView2.reloadData()
                    } else {
                    }
                }
            })
        }
    }

}

extension DispatchQueue {
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
    
    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }
}
