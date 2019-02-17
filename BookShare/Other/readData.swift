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
    //UserDataClass
    var userDataClass = UserData.userClass
    
    //ユーザーデータを読み込む
    func readMyData() {
        //データ取得開始
        db.collection("User").document(userDataClass.userID).getDocument() { (snapdata, err) in
            //エラー処理
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //データを順に取り出していく
                for key in snapdata!.data()!.keys.sorted() {
                    //該当する値を対応する値に代入していく
                    switch key {
                    case "UserName":
                        self.userDataClass.userName = snapdata![key]! as! String
                    case "UserID":
                        self.userDataClass.userID = snapdata![key]! as! String
                    case "Follow":
                        self.userDataClass.follow = snapdata![key]! as! String
                    case "Follower":
                        self.userDataClass.follower = snapdata![key]! as! String
                    case "Good":
                        self.userDataClass.good = snapdata![key]! as! String
                    case "Share":
                        self.userDataClass.share = snapdata![key]! as! String
                    case "Get":
                        self.userDataClass.get = snapdata![key]! as! String
                    case "Profile":
                        self.userDataClass.profile = snapdata![key]! as! String
                    default:
                        break
                    }
                }
            }
        }
    }
    
    //本のデータを読み込む
    func readItemData() {
        
    }

}
