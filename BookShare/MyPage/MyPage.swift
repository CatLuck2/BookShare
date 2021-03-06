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

class MyPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{
    
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
    //UserDataのインスタンス
    var userDataClass = UserData.userClass
    //readDataのインスタンス
    var readD = readData()
    //FireStore
    let db = Firestore.firestore()
    //Storageパス
    let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com")
    //localURL
    let localURL = URL(string: "")
    //画像URL
    var imageRef:URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        //キーボードのDoneボタンを設置
        createDoneButton()
        //アイコンを角丸に
        iconImage.layer.cornerRadius = 40
        iconImage.layer.masksToBounds = true
        //TextViewとCollectionViewに枠線を
        profile.layer.borderWidth = 2
        collectionItem.layer.borderWidth = 1
        //delegate
        collectionItem.delegate = self
        collectionItem.dataSource = self
        profile.delegate = self
        //各ステータスを表示
        readMyData()
        //自分が持っているアイテムデータを取得
        readD.readMyItemData(collectionView1: collectionItem)
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
            //圧縮
//            let resizeImage = image.scale(byFactor:0.3)
            //iconImageに選択した画像を格納
            self.iconImage.image = image
            //Storageに画像を保存
            saveIconImage()
            //アルバム画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Firebaseからユーザーデータとアイコンを取得する
    func readMyData() {
        //ユーザーデータを取得
        self.userName.text = userDataClass.userName
        self.userID.text = userDataClass.userID
        self.amountOfFollow.text = userDataClass.follow
        self.amountOfFollower.text = userDataClass.follower
        self.amountOfGood.text = userDataClass.good
        self.amountOfShare.text = userDataClass.share
        self.amountOfGet.text = userDataClass.get
        self.profile.text = userDataClass.profile
        //アイコン画像を取得
        //取得したらその画像を、出来なかったらプレースホルダー画像をセット
        self.iconImage!.sd_setImage(with: URL(string: self.userDataClass.iconMetaData), completed: nil)
    }
    
    //Databaseにユーザーデータを保存
    func saveMyData() {
        //保存するデータを宣言
        let userData = ["UserName":userName.text!,
                        "UserID":userID.text!,
                        "Follow":amountOfFollow.text!,
                        "Follower":amountOfFollower.text!,
                        "Good":amountOfGood.text!,
                        "Share":amountOfShare.text!,
                        "Get":amountOfGet.text!,
                        "Profile":profile.text!] as! [String : Any]
        db.collection("User").document(userDataID!).updateData(userData) { (err) in
            if let err = err {
                
            } else {
                
            }
        }
    }
    
    //Storageに画像を保存
    func saveIconImage() {
        let childString = self.userDataClass.userDataID
        //NSDataに変換
        let imageData = iconImage.image!.pngData()!
        //imageDataの拡張子を設定?
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        self.storageref.child("User").child(childString).putData(imageData, metadata: meta) { (metadata, error) in
            if error != nil {
                print("アップロードに失敗しました")
            } else {
                //URL型をNSstring型に変換したい
                self.storageref.child("User").child(childString).downloadURL(completion: { (url, error) in
                    if  error  != nil {
                        print("写真の保存に失敗")
                    }  else {
                        let imageURL = url?.absoluteString
                        self.userDataClass.iconMetaData = imageURL!
                    }
                })
            }
        }
//        DispatchQueue.main.async {
//
//        }
    }
    
    //キーボードのDoneボタンを生成
    func createDoneButton() {
        //Done
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(MyPage.commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        profile.inputAccessoryView = toolBar
    }
    
    @IBAction func menu(_ sender: Any) {
        menuAlert()
    }
    
    //メニュー用のアラート
    func menuAlert() {
        //アラート
        let alert = UIAlertController(title: "メニュー", message: nil, preferredStyle: .actionSheet)
        //このアプリについて
        alert.addAction(UIAlertAction(title: "BookShareについて", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("about")
        }))
        //このアプリの使い方
        alert.addAction(UIAlertAction(title: "使い方", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("howtouse")
        }))
        //お問い合わせ
        alert.addAction(UIAlertAction(title: "お問い合わせ", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("contact")
        }))
        //サインアウト
        alert.addAction(UIAlertAction(title: "サインアウト", style: .destructive, handler: { (action) in
            let signclass = SignOut()
            signclass.signout()
        }))
        //キャンセル
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    
    //遷移
    func go(_ identifier:String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
    //キーボードを閉じる
    @objc func commitButtonTapped() {
        saveMyData()
        self.view.endEditing(true)
    }


}
