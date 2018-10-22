//
//  CreateAccountViewController.swift
//  Jetpal
//
//  Created by Alexandr on 10/19/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    @IBAction func pickBackgroundColorPressed(_ sender: Any) {
        
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pass) {
            (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
