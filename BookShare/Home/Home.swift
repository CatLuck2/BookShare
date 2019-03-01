//
//  Home.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SDWebImage

class Home: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sc: UIScrollView!
    
    //Firebaseから取得したItemIDを格納する
    var photos = ["",""]
    //cellForItemAtが実行されたカウント
    var count_cellfunc = 0
    //Storageパス
    let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("Item")
    //スクロールビューに配置するView
    var vc = UIView()
    //readDataのインスタンス
    let readD = readData()
    //UserDataのインスタンス
    var userDataClass = UserData.userClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //複数のボタンを設置
        //vcのframe
        vc.frame = CGRect(x: 0, y: 0, width: 600, height: 55)
        //上部のスクロールビューに多数のボタンを配置
        for i in 0...6 {
            let button = UIButton()
            //サイズ
            button.frame = CGRect(x: (i*80), y: 0, width: 90, height: 55)
            //タグ
            button.tag = i
            //buttonに文字を挿入
            setTitleForButton(tag: button.tag, button: button)
            //button.titleの色
            button.setTitleColor(.black, for: .normal)
            //buttonに処理を追加
//            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
            //vcに載せる
            vc.addSubview(button)
        }
        //スクロールビューにvcを配置
        sc.addSubview(vc)
        sc.contentSize = vc.bounds.size

        collectionView.delegate = self
        collectionView.dataSource = self
        
//        readD.readMyData(collectionView1:self.collectionView)
        readD.readAllItemID(collectionView1: self.collectionView)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userDataClass.allItemID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //画像を表示
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
//        print(self.userDataClass.itemID)
        print(self.userDataClass.allItemURL)
        imageView.sd_setImage(with: self.userDataClass.allItemURL[indexPath.row], completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //DetailBookのインスタンス
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "sendDataToDetailBooks") as! DetailBooks
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "godetailbooks")
        //itemIDに該当するデータを探す
        for i in 0...self.userDataClass.allItems.count-1 {
            if self.userDataClass.allItemID[indexPath.row] == self.userDataClass.allItems[i]["0"]!["ItemID"] {
                //該当する本のデータをDetailBookに渡す
                vc1.itemData = self.userDataClass.allItems[indexPath.row]
            }
        }
        //本の詳細画面へ移行
        self.present(vc2!, animated: true, completion: nil)
    }
    
    //スクロールビューのボタンに文字を入れる
    func setTitleForButton(tag:Int, button:UIButton){
        switch tag {
        case 0:
            button.setTitle("最新", for: .normal)
        case 1:
            button.setTitle("人気", for: .normal)
        case 2:
            button.setTitle("フォロー", for: .normal)
        case 3:
            button.setTitle("文学", for: .normal)
        case 4:
            button.setTitle("社会", for: .normal)
        case 5:
            button.setTitle("科学", for: .normal)
        case 6:
            button.setTitle("ビジネス", for: .normal)
        default:
            break
        }
    }
    
    //メニュー
    @IBAction func signout(_ sender: Any) {
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

}

