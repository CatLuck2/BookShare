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
 */

import UIKit
import Firebase
import FirebaseUI

class SellBook: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
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
    //userName
    var userName = "userName"
    //userID
    var userID = "userID"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                print(imagesOfBook[indexPath.row - 1])
                
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
        //４つの項目が入力されている本をカウント
        var n = 0
        for i in 0...4 {
            //表紙画像、タイトル、カテゴリ、状態、の４つが全て入力されてるか
            if imagesOfBook[i] != nil && filenamesOfBook[i] != "" && books[i][0] != "" && books[i][1] != "" && books[i][2] != ""  {n+=1}
            //最後のループ時
            if i == 4 {
                //出品できる本が１つもない時
                if n < 1 {
                    let alert = UIAlertController(title: "エラー", message: "出品する本に未入力の項目があります", preferredStyle: .alert)
                    let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(dismiss)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //配送情報が
                if deliveryInformation[0] == "" || deliveryInformation[1] == "" || deliveryInformation[2] == "" {
                    //アラート
                    let alert = UIAlertController(title: "エラー", message: "配送情報に未入力の項目があります", preferredStyle: .alert)
                    let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(dismiss)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        
        //出品する本の数々
        var items = [["":""],["":""],["":""],["":""],["":""]]
        //出品する本
        var item = ["":""]
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
        //Database参照
        let ref = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
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
                    books[i][n] = userName
                case 7:
                    books[i][n] = userID
                case 8:
                    books[i][n] = deliveryInformation[0]
                case 9:
                    books[i][n] = deliveryInformation[1]
                case 10:
                    books[i][n] = deliveryInformation[2]
                case 11:
                    books[i][n] = randomCharacters
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
                            "DeliveryBurden":books[i][8],
                            "DeliveryWay":books[i][9],
                            "DeliveryDay":books[i][10],
                            "ItemID":books[i][11]]
            } else {
                item = ["?":"?"]
            }
            //保存用の配列に格納
            items[i] = item
        }
        
        //出品
        ref.child("Item").child(randomCharacters).setValue(items)
        //User階層に保存
        ref.child("User").child(userID).child("Item").setValue(randomCharacters)
        
        //imagesOfBookにある画像を順番に取り出し、順番に保存していく
        for i in 0...4 {
            print("1")
            //もし画像があるなら
            if imagesOfBook[i] != nil {
                print("2")
                if let image = imagesOfBook[i] as? UIImage {
                    //画像をアップロード
                    print("3")
                    uploadItemImage(childString: randomCharacters, image: image)
                }
            }
        }
        
    }
    
    //画像をアップロード
    func uploadItemImage(childString:String, image:UIImage) {
        //画像を保存
        let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child(userID).child("Item").child(childString)
        var data = NSData()
        data = image.jpegData(compressionQuality: 1.0)! as NSData
        storageref.putData(data as Data, metadata: nil) { (data, error) in
            if error != nil {
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

}
