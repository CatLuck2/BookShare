//
//  MyPage.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MyPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionItem: UICollectionView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var amountOfFollow: UILabel!
    @IBOutlet weak var amountOfFollower: UILabel!
    @IBOutlet weak var amountOfGood: UILabel!
    @IBOutlet weak var amountOfShare: UILabel!
    @IBOutlet weak var amountOfGet: UILabel!
    @IBOutlet weak var profile: UITextView!
    
    //評価数
    var grade:String!
    
    //商品
    var item:[String:String]!
    //全ての商品
    var items:[[String:String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionItem.delegate = self
        collectionItem.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionItem.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    //Item - Status（出品中）：まだシェアされてない
    @IBAction func sortDisplaying(_ sender: Any) {
    }
    //Item - Status（売り切れ）：誰かにシェアした
    @IBAction func sortShared(_ sender: Any) {
    }
    //Item - Buyer：自分がもらった
    @IBAction func sortGot(_ sender: Any) {
    }
    
    //マイページ情報をFirebaseから読みこむ
    //読み込むもの(アイコン画像、ユーザー名、ユーザーID、評価数、５つの数値、プロフィール、アイテム)
    func saveMyData() {
        //ユーザーデータを取得
        //ref1:ユーザーデータ
        let databaseRef = Database.database().reference()
        //User階層 - 各ユーザーのID
        databaseRef.child("User").child("@" + userID.text!)
        //保存するデータを宣言
        let userData = ["UserName":userName.text!,
                         "UserID":userID.text!,
                         "Grade":grade,
                         "Follow":amountOfFollow.text!,
                         "Follwer":amountOfFollower.text!,
                         "Good":amountOfGood.text!,
                         "Share":amountOfShare.text!,
                         "Get":amountOfGet.text!,
                         "Profile":profile.text!] as! [String : String]
        //保存
        databaseRef.setValue(userData)
        
        //画像を保存
        //アイコン画像をNSDataに変換
        if let imageData = iconImage.image?.pngData() {
            //ストレージパスを生成
            let storageRef = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com")
            let iconRef = storageRef.child("image/" + userID.text!)
            //アイコン画像を保存
            iconRef.putData(imageData, metadata: nil) { (metadata, error) in
                //エラー処理
                guard let _ = metadata else  {
                    return
                }
            }
        }
        
    }
    
    //マイページ情報をFirebaseに保存
    //保存するもの(アイコン画像、ユーザー名、プロフィール)
    func readMyData() {
        //ユーザーデータを取得
        let ref = Database.database().reference()
         ref.child("User")
            .queryOrdered(byChild: userID.text!)
            .observe(.value) { (snap, error) in
                let snapdata = snap.value as! [String:NSDictionary]
                if snapdata != nil {
                    return
                }
                //item,itemsを初期化
//                self.item = []
//                self.items = [[]]
                for key in snapdata.keys.sorted() {
                    let read_data = snapdata[key]
                    //データを格納して行く
                    if let username = read_data!["UserName"] as? String,
                        let userid = read_data!["UserID"] as? String,
                        let grade = read_data!["Grade"] as? String,
                        let follow = read_data!["Follow"] as? String,
                        let follower = read_data!["Follower"] as? String,
                        let good = read_data!["Good"] as? String,
                        let share = read_data!["Share"] as? String,
                        let get = read_data!["Get"] as? String,
                        let proFile = read_data!["Profile"] as? String {
                        self.userName.text = username
                        self.userID.text = userid
                        self.grade = grade
                        self.amountOfFollow.text = follow
                        self.amountOfFollower.text = follower
                        self.amountOfGood.text = good
                        self.amountOfShare.text = share
                        self.amountOfGet.text = get
                        self.profile.text = proFile
                    }
                }
        }
        
        //画像を取得
        //画像パスを生成
        let storageRef = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com")
        //画像を取得
        let iconRef = storageRef.child("image/" + userID.text!)
        //プレースホルダー画像
        let placeholderImage = UIImage(named: "placeholder.png")
        //取得したらその画像を、出来なかったら予備の画像をセット
        self.iconImage.sd_setImage(with: iconRef, placeholderImage: placeholderImage)
        
        //アイテムを取得
        //Item - UserName,UserID：２つが一致するItemだけを取得
        
                
    }

}
