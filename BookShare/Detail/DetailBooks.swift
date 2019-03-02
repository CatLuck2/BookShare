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
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var numberOfGood: UILabel!
    
    //tableViewの中身
    var cellArray = ["出品する本","配送情報","発送日の目安","配送料の負担","発送の方法"]
    //配送情報の各項目
    var deliveryInformation = ["","",""]
    //ホームで選択した本のデータ
    var itemData = [String:[String:String]]()
    //UserDataClass
    var userDataClass = UserData.userClass
    //画面遷移時に必要なindexPath
    var indexPathRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageViewのプレースホルダー
        imageView.isHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
        
        //Navigationbarのタイトる
        self.navigationItem.title = itemData["0"]!["Title"]
        
        //userIconを表示
        if self.userDataClass.iconMetaData != nil {
            self.userIcon.sd_setImage(with: URL(string: self.userDataClass.iconMetaData!), completed: nil)
        } else {
            self.userIcon.image = UIImage(named: "Icon.png")
        }
        //uesrLabelを表示
        userLabel.text = itemData["0"]!["UserName"]
        
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
        case "出品する本":
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        case "本":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = self.itemData["\(indexPath.row - 1)"]!["Title"]!
        case "配送情報":
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        case "配送料の負担":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = self.itemData["0"]!["DeliveryBurden"]
        case "発送の方法":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = self.itemData["0"]!["DeliveryWay"]
        case "発送日の目安":
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
            cell.detailTextLabel?.text = self.itemData["0"]!["DeliveryDay"]
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathRow = indexPath.row
        performSegue(withIdentifier: "goDetailBooks2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailBooks2" {
            //Detailbooks2のインスタンス
            let vc = segue.destination as! DetailBooks2
            //"本を追加"をタップした場合
            switch cellArray[indexPathRow] {
            case "本":
                //画像URLを渡す
                //            vc.imageURL =
                //タイトル、カテゴリ、本の状態を渡す
                vc.bookData = self.itemData["\(indexPathRow - 1)"]!
            default:
                break
            }
        }
    }
    
    //allItemsの中身に応じてcellArrayの中身を整理
    func arrangeCellArray() {
        for i in 0...4 {
            //もしデータがあるなら本を追加
            if itemData["\(i)"]!["Title"] != nil {
                //cellArrayに本のタイトルを挿入
                self.cellArray.insert("本", at: cellArray.count - 4)
                self.tableView.reloadData()
            } else {
            }
        }
    }
    
    @IBAction func goodButton(_ sender: Any) {
        //いいね数を+1
        //FireStoreのGood数を更新
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeComment(_ sender: Any) {
    }
    
    @IBAction func sendApproval(_ sender: Any) {
        let alert = UIAlertController(title: "完了", message: "シェアを希望しました。", preferredStyle: .alert)
        //このアプリについて
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
