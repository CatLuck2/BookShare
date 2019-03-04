//
//  saveData.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/21.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

class saveData: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Databaseにユーザーデータを保存
//    func saveMyData(username:String,
//                    userid:String,
//                    follow:String,
//                    follower:String,
//                    good:String,
//                    share:String,
//                    get:String,
//                    profile:String,
//                    :String,
//                    username:String) {
//        //保存するデータを宣言
//        let userData = ["UserName":userName.text!,
//                        "UserID":userID.text!,
//                        "Follow":amountOfFollow.text!,
//                        "Follower":amountOfFollower.text!,
//                        "Good":amountOfGood.text!,
//                        "Share":amountOfShare.text!,
//                        "Get":amountOfGet.text!,
//                        "Profile":profile.text!] as! [String : Any]
//        db.collection("User").document(userDataID!).updateData(userData) { (err) in
//            if let err = err {
//                
//            } else {
//                
//            }
//        }
//    }

}
