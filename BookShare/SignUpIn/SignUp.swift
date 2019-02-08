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
    
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailForm.delegate = self
        passForm.delegate = self
        
        mailForm.layer.borderWidth = 1
        mailForm.layer.cornerRadius = 10
        passForm.layer.borderWidth = 1
        passForm.layer.cornerRadius = 10
    }
    
    @IBAction func signup(_ sender: Any) {
        //２つのフォームが入力されてる場合
        if mailForm.text != "" && passForm.text != "" {
            //入力したパスワードが7文字以上の場合
            if (passForm.text?.count)! > 6  {
                Auth.auth().createUser(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                    if error == nil {
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            if error == nil {
                                print("success")
                            }
                        })
                    } else {
                        print(error)
                    }
                }
            //入力したパスワードが6文字以下の場合
            } else {
                let alert = UIAlertController(title: "エラー", message: "7文字以上のパスワードを入力してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        //いずれかのフォームが未入力の場合
        } else {
            let alert = UIAlertController(title: "エラー", message: "入力されてない箇所があります。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //ログイン画面に移行
    @IBAction func changeToLogin(_ sender: Any) {
        performSegue(withIdentifier: "gosignin", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailForm.resignFirstResponder()
        passForm.resignFirstResponder()
    }
    
}
