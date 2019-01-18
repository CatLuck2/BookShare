//
//  MyPage.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

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
    var grade:Int!
    
    //商品
    var item:BookItem!
    //所持商品
    var items:[BookItem]!

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
    
    @IBAction func sortAll(_ sender: Any) {
    }
    
    @IBAction func sortDisplay(_ sender: Any) {
    }
    
    @IBAction func sortShared(_ sender: Any) {
    }
    
    @IBAction func sortGet(_ sender: Any) {
    }
    
    //マイページ情報をFirebaseから読みこむ
    //読み込むもの(アイコン画像、ユーザー名、ユーザーID、評価数、５つの数値、プロフィール、アイテム)
    func readMyData() {
        //データベースの参照
        let ref = Database.database().reference()
        //User階層 - 各ユーザーのID
        ref.child("User").childByAutoId()
        //保存するデータを宣言
        _ = ["Icon":iconImage.getFileName()!,
                         "UserName":userName.text ?? "userName",
                         "UserID":userID.text ?? "userID",
                         "Grade":grade,
                         "Follow":amountOfFollow,
                         "Follwer":amountOfFollower,
                         "Good":amountOfGood,
                         "Share":amountOfShare,
                         "Get":amountOfGet,
                         "Profile":profile.text,
                         "Item":items,] as [String : Any]
    }
    
    //マイページ情報をFirebaseに保存
    //保存するもの(アイコン画像、ユーザー名、プロフィール)
    //touchesBegan時に実行
    func saveMyData() {
        let ref = Database.database().reference()
         ref.child("User")
            .queryOrderedByKey()
            .observe(.value) { (snap, error) in
                let snapdata = snap.value as! [String:NSDictionary]
                if snapdata != nil {
                    return
                }
                //item,itemsを初期化
                self.item = BookItem()
                self.items = [BookItem()]
                for key in snapdata.keys.sorted() {
                    let read_data = snapdata[key]
                    //データを格納して行く
                    if let _ = read_data!["username"] as? String{
                        
                    }
                    //〜〜に追加
                }
                //各UI情報を更新
        }
                
    }

}

//UIImageのファイル名を取得
extension UIImageView {
    func getFileName() -> String? {
        return self.image!.accessibilityIdentifier
    }
}
