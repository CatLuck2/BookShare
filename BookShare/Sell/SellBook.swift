//
//  SellBook.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//
/*
 "Title":books[i][0],
 "Category":books[i][1],
 "State":books[i][2],
 "ItemID":books[i][3], //ID
 "Date":books[i][4], //出品日時
 "Status":"display", //出品中？売り切れ？
 "Good":books[i][6], //いいね数
 "UserName":books[i][7], //出品者の名前
 "UserID":books[i][8], //出品者のID
 "DeliveryArea":books[i][9], //発送元地域
 "DeliveryBurden":books[i][10], //配送料の負担
 "DeliveryWay":books[i][11], //配送方法
 "DeliveryDay":books[i][12] //発送日の目安
 
 //        DispatchQueue.main.async {
 //
 //        }
 */

import UIKit
import Firebase
import FirebaseUI

class SellBook: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //FireStore
    let db = Firestore.firestore()
    //UserDataClass
    var userDataClass = UserData.userClass
    //userDataID
    let userDataID = UserDefaults.standard.string(forKey: "userDataID")
    //乱数を保持しておく変数
    var randomString = String()
    var items = ["0":"","1":"","2":"","3":"","4":""] as! [String:Any]
    //出品する本
    var item = ["":""] as! [String:Any]
    //出品する本の数々
    var books = [["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""]]
    //出品する本
    var book = ["","",""]
    //出品する本の画像
    var imagesOfBook = [UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png")] as! [UIImage]
    //出品する本の画像のファイル名
    var filenamesOfBook = ["","","","",""]
    //配送情報の各項目
    var deliveryInformation = ["","",""]
    //tableViewの中身
    var cellArray = ["出品する本","本","本を追加","配送情報","配送料の負担","発送の方法","発送日の目安"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //imageViewのプレースホルダー
        imageView.image = UIImage(named: "placeholder_book.png")
        //空のセルを削除
        tableView.tableFooterView = UIView()
        
        print(self.userDataClass.userName)
        print(self.userDataClass.userID)
        print(self.userDataClass.userDataID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //乱数を生成しておく（乱数が複数生成されるのを防ぐため）
//        randomString = createRandomString()
        //UserData.itemにItemのIDを追加
//        userDataClass.item.append(childString)
        //リロード
        tableView.reloadData()
        imageView.image = imagesOfBook[0]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        //セルのテキストで装飾を分岐
        switch cell.textLabel?.text {
        case "配送情報":
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        case "出品する本":
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        case "本を追加":
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = ""
        case "本":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = self.books[indexPath.row - 1][0]
        case "配送料の負担":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = deliveryInformation[0]
        case "発送の方法":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = deliveryInformation[1]
        case "発送日の目安":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = deliveryInformation[2]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //"本を追加"をタップした場合
        switch cellArray[indexPath.row] {
        case "本を追加":
            cellArray[indexPath.row] = "本"
            if cellArray.count < 10 {
                cellArray.insert("本を追加", at: cellArray.count - 4)
            }
        case "本":
            let vc = storyboard?.instantiateViewController(withIdentifier: "sellbooks") as! SellBooks
            //何番目の本かを示す数字
            vc.numberOfBook = indexPath.row - 1
            //表紙画像
            if let _ = imagesOfBook[indexPath.row - 1] as? UIImage {
                vc.getImage = imagesOfBook[indexPath.row - 1]
            } else {}
            if let _ = books[indexPath.row - 1] as? [String] {
                vc.settingArray = books[indexPath.row - 1]
            } else {vc.settingArray = ["","IT","目立った傷なし"]}
            self.navigationController?.pushViewController(vc, animated: true)
        case "配送料の負担":
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingDelivery") as! SettingDeliveryInformation
            vc.flag = "配送料の負担"
            self.navigationController?.pushViewController(vc, animated: true)
        case "発送の方法":
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingDelivery") as! SettingDeliveryInformation
            vc.flag = "発送の方法"
                self.navigationController?.pushViewController(vc, animated: true)
        case "発送日の目安":
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingDelivery") as! SettingDeliveryInformation
            vc.flag = "発送日の目安"
                self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //セルを削除する
        if editingStyle == .delete {
            //本1~本５以外には適用しない
            if cellArray[indexPath.row] == "本" {
                cellArray.remove(at: indexPath.row)
                self.books.remove(at: indexPath.row - 1)
                self.books.append(["","",""])
                self.imagesOfBook.remove(at: indexPath.row - 1)
                self.imagesOfBook.append(UIImage(named: "")!)
                self.filenamesOfBook.remove(at: indexPath.row - 1)
                self.filenamesOfBook.append("")
                tableView.deleteRows(at: [indexPath], with: .fade)
                //もし本のセルが5つ以下になったら
                if cellArray.count <= 10 {
                    //既に”本の追加”のセルがあるか
                    if cellArray.contains("本を追加") == false {
                        cellArray.insert("本を追加", at: 5)
                        tableView.reloadData()
                    }
                }
            }
        } else {}
    }

    @IBAction func sellBook(_ sender: Any) {
        //出品する本の数々
        items = ["0":"","1":"","2":"","3":"","4":""]
        //出品する本
        item = ["":""]
        //ItemIDの生成
        randomString = createRandomString()
        //ItemIDを追加
        userDataClass.myItemID.append(randomString)
        
        //４つの項目が入力されている本をカウント
        var n = 0
        for i in 0...4 {
            //表紙画像、タイトル、カテゴリ、状態、の４つが全て入力されてるか
            if imagesOfBook[i] != nil && filenamesOfBook[i] != "" && books[i][0] != "" && books[i][1] != "" && books[i][2] != ""  {n+=1}
            //最後のループ時
            if i == 4 {
                //出品できる本が１つもない時
                if n < 1 {
                    self.alert(title: "エラー", message: "出品する本に未入力の項目があります", actiontitle: "OK")
                    return
                }
                //配送情報が
                if deliveryInformation[0] == "" || deliveryInformation[1] == "" || deliveryInformation[2] == "" {
                    self.alert(title: "エラー", message: "出品する本に未入力の項目があります", actiontitle: "OK")
                    return
                }
            }
        }
        //booksの各要素に保存に必要なデータを入れていく
        for i in 0...4 {
            for n in 3...11 {
                switch n {
                case 3:
                    let f = DateFormatter()
                    f.timeStyle = .medium
                    f.dateStyle = .medium
                    f.locale = Locale(identifier: "ja_JP")
                    books[i][n] = f.string(from: Date())
                case 4:
                    books[i][n] = "display"
                case 5:
                    books[i][n] = "0"
                case 6:
                    books[i][n] = userDataClass.userName
                case 7:
                    books[i][n] = userDataClass.userID
                case 8:
                    books[i][n] = userDataClass.userDataID
                case 9:
                    books[i][n] = deliveryInformation[0]
                case 10:
                    books[i][n] = deliveryInformation[1]
                case 11:
                    books[i][n] = deliveryInformation[2]
                default:
                    break
                }
            }
        }
        //出品する本の数だけitemを宣言&格納
        for i in 0...4 {
            //1冊のデータを格納
            //もし未入力の本があれば
            if imagesOfBook[i] != nil && filenamesOfBook[i] != "" && books[i][0] != "" && books[i][1] != "" && books[i][2] != "" {
                item = ["Title":books[i][0],
                            "Category":books[i][1],
                            "State":books[i][2],
                            "Date":books[i][3],
                            "Status":books[i][4],
                            "Good":books[i][5],
                            "UserName":books[i][6],
                            "UserID":books[i][7],
                            "UserDataID":books[i][8],
                            "DeliveryBurden":books[i][9],
                            "DeliveryWay":books[i][10],
                            "DeliveryDay":books[i][11],
                            "ItemID":randomString]
            } else {
                item = ["?":"?"]
            }
            //保存用の配列に格納
            items["\(i)"] = item
        }
        
        //FireStoreに保存
        //保存するデータを宣言
        let userData : [String:Any] = [
            "UserName":userDataClass.userName,
            "UserID":userDataClass.userID,
            "Follow":userDataClass.follow,
            "Follower":userDataClass.follower,
            "Good":userDataClass.good,
            "Share":userDataClass.share,
            "Get":userDataClass.get,
            "Profile":userDataClass.profile,
            "Item":userDataClass.myItemID]
        
        //アイテムを保存
        db.collection("Item").document(randomString).setData(items) { (err) in
            if let _ = err {
                print("fail")
            } else {
                print("success")
            }
        }
        
        //ユーザーデータを保存
        db.collection("User").document(userDataID!).setData(userData) { (err) in
            if err != nil {
                print("fail")
            } else {
                print("success")
            }
        }
        
        //imagesOfBookにある画像を順番に取り出し、順番に保存していく
        for i in 0...4 {
            //もし画像があるなら
            if self.imagesOfBook[i] != nil {
                if let image = self.imagesOfBook[i] as? UIImage {
                    //画像をアップロード
                    self.saveItemImage(childString: randomString, image: image)
                }
            }
        }
        //リセット
        resetAllSettings()
    }
    
    //画像をアップロード
    func saveItemImage(childString:String, image:UIImage) {
        //画像を保存
        let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("Item").child(childString)
        var data = NSData()
        data = image.jpegData(compressionQuality: 1.0)! as NSData
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        //Storageに保存
        storageref.putData(data as Data, metadata: meta) { (data, error) in
            if error != nil {
                print(error)
            } else {
            }
        }
    }
    
    //設定を初期化する
    func resetAllSettings() {
        //現設定を全て初期化する
        books = [["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""],
                 ["","","","","","","","","","","",""]]
        imagesOfBook = [UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png"),
                        UIImage(named: "sample.png")] as! [UIImage]
        imageView.image = UIImage(named: "sample.png")
        filenamesOfBook = ["","","","",""]
        deliveryInformation = ["","",""]
        cellArray = ["出品する本","本","本を追加","配送情報","配送料の負担","発送の方法","発送日の目安"]
        tableView.reloadData()
        //1番上にスクロール
        let bottomOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(bottomOffset, animated: false)
        //閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    //乱数を生成
    func createRandomString() -> String {
        //ItemIDを生成
        //乱数の生成に使用する文字
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        //乱数を格納する配列
        var randomArray:String!
        //charactersの中からランダムに選出した要素番号を格納する
        var len = Int()
        //乱数(文字)をいくつか追加し、最終的に乱数(文字列)となる変数
        var randomCharacters = String()
        //乱数が9文字になるまで続く
        for _ in 1...9 {
            //charactersの要素番号をランダムに選出
            len = Int(arc4random_uniform(UInt32(characters.count)))
            //aからlen番目の文字をrandomCharactersに追加する
            //1ループ/1文字、追加される
            randomCharacters += String(characters[characters.index(characters.startIndex,offsetBy: len)])
        }
        return randomCharacters
    }
    
    @IBAction func menu(_ sender: Any) {
        menuAlert()
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
