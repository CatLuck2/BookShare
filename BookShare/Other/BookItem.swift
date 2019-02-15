//
//  BookItem.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/18.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//
/*

 itemID：本のID
 status：出品中/売り切れ
 detailItem：商品の中身（1冊、複数冊）
 date：出品日時
 good：いいね数
 icon：ユーザーアイコン名
 userName：ユーザーネーム
 userID：ユーザーID
 grade：ユーザーの評価数
 detailDelivery：配送情報(地域、負担、方法、) 
 comment：コメント
 
 
 */

import UIKit

class BookItem: NSObject {
    
    var itemID:String!
    var status:String!
    var detailItem:Array<String>!
    var date:String!
    var good:String!
    var icon:String!
    var userName:String!
    var userID:String!
    var grade:Int!
    var detailDelivery:Array<String>!
    var comment:Array<Dictionary<String, String>>!

}
