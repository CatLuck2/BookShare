//
//  SellBook.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//
/*
本の末尾　挿入する位置　要素の数
1 3 7 1
3 4 8 2
 
 
 */

import UIKit
import Firebase
import FirebaseUI

class SellBook: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //出品する本の数々
    var books = [[],[],[],[],[]] as! [[String]]
    //出品する本
    var book = [] as! [String]
    //出品する本の画像
    var imagesOfBook:[UIImage]!
    //userID
    var userID:String!
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
            cell.detailTextLabel?.text = ""
        case "出品する本":
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            cell.detailTextLabel?.text = ""
        case "本を追加":
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = ""
        case "本":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = "タイトル"
        case "配送料の負担":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = "出品者"
        case "発送の方法":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = "ヤマト"
        case "発送日の目安":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = "1~2日で発想"
        default:
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //"本を追加"をタップした場合
        if cellArray[indexPath.row] == "本を追加" {
            cellArray[indexPath.row] = "本"
            if cellArray.count < 10 {
                cellArray.insert("本を追加", at: cellArray.count - 4)
            }
        //本1~本5をタップした場合
        } else if cellArray[indexPath.row].count == 1 && cellArray[indexPath.row].contains("本") {
            let vc = storyboard?.instantiateViewController(withIdentifier: "sellbooks") as! SellBooks
            vc.numberOfBook = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //セルを削除する
        if editingStyle == .delete {
            //本1~本５以外には適用しない
            if cellArray[indexPath.row] == "本" {
                cellArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if cellArray.count <= 10 {
                    if cellArray.contains("本を追加") == false {
                        cellArray.insert("本を追加", at: 5)
                        tableView.reloadData()
                    }
                }
            }
        }
    }

    @IBAction func sellBook(_ sender: Any) {
        if books.count == 0 {
            //アラート
        }
        //出品する本の数々
        var items:[[String:String]]!
        //Database参照
        let ref = Database.database().reference()
        //Item階層
        ref.child("Item")
        //出品する本の数だけitemを宣言&格納
        for i in 0..<books.count {
            //1冊のデータを格納
            var item = ["Title":books[i][0],
                        "Category":books[i][1],
                        "State":books[i][2],
                        "ItemID":books[i][3],
                        "Date":books[i][4],
                        "Status":"display",
                        "Good":books[i][6],
                        "UserName":books[i][7],
                        "UserID":books[i][8],
                        "DeliveryArea":books[i][9],
                        "DeliveryBurden":books[i][10],
                        "DeliveryWay":books[i][11],
                        "DeliveryDay":books[i][12],] as! [String : String]
            //保存用の配列に格納
            items.append(item)
        }
        //保存
        ref.setValue(items)
        
        //画像を保存
        //アイコン画像をNSDataに変換
//        if let imageData = iconImae.image?.pngData() {
//            //ストレージパスを生成
//            let storageRef = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com")
//            let iconRef = storageRef.child("image/" + userID.text!)
//            //アイコン画像を保存
//            iconRef.putData(imageData, metadata: nil) { (metadata, error) in
//                //エラー処理
//                guard let _ = metadata else  {
//                    return
//                }
//            }
//        }
    }
    

}
