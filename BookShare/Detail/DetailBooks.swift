//
//  DetailBooks.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class DetailBooks: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
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
    //tableViewの中身
    var cellArray = ["出品する本","配送情報","配送料の負担","発送の方法","発送日の目安"]
    
    //ホームで選択した本のデータ
    var itemData = [String:Any]()
    //UserDataClass
    //UserDataClass
    var userDataClass = UserData.userClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageViewのプレースホルダー
        imageView.isHidden = false
        
        print(userDataClass.allItems)
        
        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
        //cellArrayの中身を整理
        arrangeCellArray()
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
        case "本":
//            let vc = storyboard?.instantiateViewController(withIdentifier: "sellbooks") as! SellBooks
            //何番目の本かを示す数字
//            vc.numberOfBook = indexPath.row - 1
//            //表紙画像
//            if let _ = imagesOfBook[indexPath.row - 1] as? UIImage {
//                vc.getImage = imagesOfBook[indexPath.row - 1]
//            } else {}
//            if let _ = books[indexPath.row - 1] as? [String] {
//                vc.settingArray = books[indexPath.row - 1]
//            } else {vc.settingArray = ["","IT","目立った傷なし"]}
//            self.navigationController?.pushViewController(vc, animated: true)
            //Detailbooks2に遷移
            self.performSegue(withIdentifier: "detailbooks2", sender: nil)
        default:
            break
        }
        tableView.reloadData()
    }
    
    //allItemsの中身に応じてcellArrayの中身を整理
    func arrangeCellArray() {
        for i in 0...4 {
            //もしデータがあるなら本を追加
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeComment(_ sender: Any) {
    }
    
    @IBAction func sendApproval(_ sender: Any) {
    }
    
}
