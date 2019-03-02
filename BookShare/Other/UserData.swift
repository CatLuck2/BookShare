//
//  UserData.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/15.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class UserData: NSObject {
    static let userClass = UserData()
    var userName = String()
    var userID = String()
    var userDataID = String()
    var follow = String()
    var follower = String()
    var good = String()
    var share = String()
    var get = String()
    var profile = String()
    //ユーザーアイコンの画像URL
    var iconMetaData:String!
    //全アイテムのID
    var allItemID = [String]()
    //自分のアイテムID
    var myItemID = [String]()
    //全アイテムURL
    var allItemURL = [URL]()
    //自分のアイテムURL
    var myItemURL = [URL]()
    //全アイテムデータ
    var allItems:[[String:[String:String]]] = [[:]]
    //自分のアイテムデータ
    var myItems:[[String:[String:String]]] = [[:]]
}
