//
//  SellBooks.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class SellBooks: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //選択した本の番号
    var numberOfBook:Int!
    //設定項目
    let array = ["タイトル","カテゴリ","本の状態"]
    //出品画面に渡す配列
    var settingArray = ["","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
        
        imageView.image = UIImage(named: "placeholderbook.png")
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let titleAlert = UIAlertController(title: "タイトル", message: "本のタイトルを入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //textFieldを配列に格納
                guard let textfield:[UITextField] = titleAlert.textFields else {return}
                //配列からテキストを取り出す
                for textField in textfield {
                    switch textField.tag {
                    case 0:
                        if textField.text == "" {
                            return
                        } else {
                            //textFieldに入力した内容をsettingArray[0]に格納
                            self.settingArray[0] = textField.text!
                            titleAlert.dismiss(animated: true, completion: nil)
                        }
                    default: break
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
                titleAlert.dismiss(animated: true, completion: nil)
            })
            //アラートにtextFieldを追加
            titleAlert.addTextField { (text:UITextField!) in
                text.placeholder = "例：金持ち父さんと貧乏父さん"
                text.tag = 0
            }
            titleAlert.addAction(okAction)
            titleAlert.addAction(cancelAction)
            self.present(titleAlert, animated: true, completion: nil)
        case 1:
            let alert = UIAlertController(title: "メニュー", message:  nil, preferredStyle: .alert)
            //ログアウト
            let logoutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
                NCMBUser.logOutInBackground({ (error) in
                    if error != nil {
                        print("logout error")
                    } else {
                        //ログアウト
                        self.syncronize()
                    }
                })
            }
            //退会
            let deleteAction = UIAlertAction(title: "退会", style: .destructive) { (action) in
                let user = NCMBUser.current()
                user?.deleteInBackground({ (error) in
                    if error != nil {
                        print("delete error")
                    } else {
                        //ログアウト
                        self.syncronize()
                    }
                })
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(logoutAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        case 2:
            <#code#>
        default:
            <#code#>
        }
    }
    
    @IBAction func imageTapGesture(_ sender: Any) {
        //アルバムを指定
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
    
    @IBAction func finishSetting(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sellbook") as! SellBook
        vc.book[0] = settingArray[0]
        vc.book[1] = settingArray[1]
        vc.book[2] = settingArray[2]
        vc.books[numberOfBook] = vc.book
        vc.book = []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imagePickerController
        (_ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imageにアルバムで選択した画像が格納される
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //ImageViewに表示
            self.imageView.image = image
            //アルバム画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
