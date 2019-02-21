//
//  readData.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/17.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

class readData: UIViewController {

    //FireStore
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    //Storageパス
    let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("User")
    //UserDataClass
    var userDataClass = UserData.userClass
    
    //ユーザーデータを読み込む
    func readMyData() {
        //ユーザーデータ
        self.db.collection("User").getDocuments() { (snapdata, err) in
            //エラー処理
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //                print(snapdata!)
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
                        default:
                            break
                        }
                    }
                }
            }
        }
//        DispatchQueue.main.async {
//
//        }
    }
    
    //ユーザーアイコン
    func readMyIcon() {
        self.storageref.child("Icon").downloadURL(completion: { (url, error) in
            if error != nil {
            } else {
                if url == nil {
                    self.userDataClass.iconMetaData = "failfjawegja@"
                } else {
                    self.userDataClass.iconMetaData = url!.absoluteString
                }
            }
        })
    }
    //            DispatchQueue.main.async {
    //
    //            }
    
    //本のデータを読み込む
    func readItemData() {
        
    }

}
