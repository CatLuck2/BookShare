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

class MyPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
    var item = [String]()
    var items = [[String]]()
    //userDataID
    let userDataID = UserDefaults.standard.string(forKey: "userDataID")

    override func viewDidLoad() {
        super.viewDidLoad()
        //userNameとuserIDを取得
//        if let user = Auth.auth().currentUser {
//            userName.text = user.displayName
//            userID.text = "@" + user.uid
//            print(user.displayName)
//        } else {}
        //アイコンを角丸に
        iconImage.layer.cornerRadius = 10
        iconImage.layer.masksToBounds = true
        collectionItem.delegate = self
        collectionItem.dataSource = self
        //ユーザーデータを取得
        readMyData()
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
    
    //ImageViewをタップした時
    @IBAction func tapImageView(_ sender: Any) {
        //アルバムを開く
        let sourceType:UIImagePickerController.SourceType
            = UIImagePickerController.SourceType.photoLibrary
        //アルバムを立ち上げる
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            //アルバム画面を開く
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController
        (_ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imageにアルバムで選択した画像が格納される
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //iconImageに選択した画像を格納
            self.iconImage.image = image
            //Storageに画像を保存
            //アルバム画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Firebaseからユーザーデータとアイコンを取得する
    func readMyData() {
        //ユーザーデータを取得
        let ref = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
        ref.child("User")
            .child(UserDefaults.standard.string(forKey: "userDataID")!)
//            .queryOrdered(byChild: )
            .observe(.value) { (snap, error) in
//                let snapdata = snap.value as!
                let snapdata = snap.value as? Dictionary<String,String>
                if snapdata == nil {
                    return
                }
//                item,itemsを初期化
//                self.item = []
//                self.items = [[]]
                for key in snapdata!.keys.sorted() {
//                    let read_data =
//                    print(key)
//                    print(snapdata![key]!)
//                    データを格納して行く
                    switch key {
                    case "UserName":
                        self.userName.text = snapdata![key]
                    case "UserID":
                        self.userID.text = snapdata![key]
                    case "Follow":
                        self.amountOfFollow.text = snapdata![key]
                    case "Follower":
                        self.amountOfFollower.text = snapdata![key]
                    case "Good":
                        self.amountOfGood.text = snapdata![key]
                    case "Share":
                        self.amountOfShare.text = snapdata![key]
                    case "Get":
                        self.amountOfGet.text = snapdata![key]
                    case "Profile":
                        self.profile.text = snapdata![key]
                    default:
                        break
                    }
//                    if key == "UserName" ||
//                        key == "UserID" ||
//                        key == "Follow" ||
//                        key == "Follower" ||
//                        key == "Good" ||
//                        key == "Share" ||
//                        key == "Get" ||
//                        key == "Profile" {
//
//                    }
                }
        }
        //アイコン画像を取得
        //画像パスを生成
        let storageRef = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("userDataID").child(userDataID!).child("Icon")
        //取得したらその画像を、出来なかったらプレースホルダー画像をセット
        self.iconImage.sd_setImage(with: storageRef, placeholderImage: UIImage(named: "placeholderImage"))
    }
    
    //Databaseにユーザーデータを保存
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
    }
    
    //Storageに画像を保存
    func saveIconImage() {
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

}
