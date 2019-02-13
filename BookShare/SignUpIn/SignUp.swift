//
//  SignUpOrIn.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/06.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameForm: UITextField!
    @IBOutlet weak var userIDForm: UITextField!
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    
    //userDataID
    var userDataID = UserDefaults.standard.string(forKey: "userDataID")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameForm.delegate = self
        userIDForm.delegate = self
        mailForm.delegate = self
        passForm.delegate = self
        
        userNameForm.layer.borderWidth = 1
        userNameForm.layer.cornerRadius = 10
        userIDForm.layer.borderWidth = 1
        userIDForm.layer.cornerRadius = 10
        mailForm.layer.borderWidth = 1
        mailForm.layer.cornerRadius = 10
        passForm.layer.borderWidth = 1
        passForm.layer.cornerRadius = 10
    }
    
    //サインアップ
    @IBAction func signup(_ sender: Any) {
        //２つのフォームが入力されてる場合
        if mailForm.text != "" && passForm.text != "" {
            //入力したパスワードが7文字以上の場合
            if (passForm.text?.count)! > 6  {
                Auth.auth().createUser(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                    if error == nil {
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            if error == nil {
                                //ログイン状態をtrueに
                                let ud = UserDefaults.standard
                                ud.set(true, forKey: "loginStatus")
                                ud.synchronize()
                                //ユーザー名をセット
                                if let user = Auth.auth().currentUser {
                                    let changeRequest = user.createProfileChangeRequest()
                                    changeRequest.displayName = self.userNameForm.text!
                                }
                                //ユーザーデータを作成
                                self.createUserData()
                                //ホーム画面に遷移
                                let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
                                let rootViewController = storyboard.instantiateViewController(withIdentifier: "Main")
                                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            }
                        })
                    } else {
                        print(error)
                    }
                }
            //入力したパスワードが6文字以下の場合
            } else {
                self.alert(title: "エラー", message: "7文字以上のパスワードを入力してください。", actiontitle: "OK")
            }
        //いずれかのフォームが未入力の場合
        } else {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
        }
    }
    
    //ログイン画面に移行
    @IBAction func changeToLogin(_ sender: Any) {
        performSegue(withIdentifier: "gosignin", sender: nil)
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //ユーザーデータを新規作成
    func createUserData() {
        //ref1:ユーザーデータ
        let databaseRef = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
        //User階層 - 各ユーザーのID
        //保存するデータを宣言
        let userData = ["UserName":userNameForm.text!,
                        "UserID":userIDForm.text!,
                        "Grade":"0",
                        "Follow":"0",
                        "Follwer":"0",
                        "Good":"0",
                        "Share":"0",
                        "Get":"0",
                        "Profile":""]
        let itemData = [["?":"?"],["?":"?"],["?":"?"],["?":"?"],["?":"?"]] as! [[String:String]]
        //保存
        databaseRef.child("User").child((Auth.auth().currentUser?.uid)!).setValue(userData)
        databaseRef.child("Item").child((Auth.auth().currentUser?.uid)!).setValue(itemData)
        
        //UserDefaultsにuserIDを保存
        let ud = UserDefaults.standard
        ud.set((Auth.auth().currentUser?.uid)!, forKey: "userDataID")
        ud.synchronize()
        userDataID = UserDefaults.standard.string(forKey: "userDataID")
        
        //Storageにプレースホルダー用の画像を保存
        //画像を保存
        let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child("userDataID").child(userDataID!).child("Icon")
        var data = NSData()
        data = UIImage(named: "placeholder.png")!.jpegData(compressionQuality: 1.0)! as NSData
        storageref.putData(data as Data, metadata: nil) { (data, error) in
            if error != nil {
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameForm.resignFirstResponder()
        userIDForm.resignFirstResponder()
        mailForm.resignFirstResponder()
        passForm.resignFirstResponder()
    }
    
}
