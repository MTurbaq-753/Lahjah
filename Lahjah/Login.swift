//
//  Login.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 07/01/2022.
//

import UIKit
import Firebase

protocol LoginDelegate {
    func didLogin()
}

class Login: UIViewController{
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var englishEmail: UILabel!
    
    @IBOutlet weak var arabicEmail: UILabel!
    
    @IBOutlet weak var englishPassword: UILabel!
    @IBOutlet weak var arabicPassword: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    var delegate: LoginDelegate?
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    @IBOutlet weak var passwordCriteria: UITextView!
    
    override func viewDidLoad() {
        passwordCriteria.isHidden = true
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right

        let myAttrString = NSMutableAttributedString(string: K.passwordCriteriaArabic, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.paragraphStyle: style])
        
        if K.AppCurrentLanguage == "Arabic"{
            
            forgotPassword.setTitle("نسيت كلمة المرور", for: .normal)
            englishEmail.isHidden = true
            englishPassword.isHidden = true
            
            passwordCriteria.attributedText = myAttrString
        }
        else {arabicEmail.isHidden = true
            arabicPassword.isHidden = true
        }
        loginButton.setTitle(K.currentLanguage.LoginButton![0], for: .normal)
    }


    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            if password.range(of: K.passwordPattern, options: .regularExpression) == nil{
                passwordCriteria.isHidden = false
                let popAlert = UIAlertController(title: "Error", message: "Wrong password", preferredStyle: UIAlertController.Style.alert)
                popAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in}))
                present(popAlert, animated: true, completion: nil)}
            else{
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {print(e)} else{
                        K.User = email
                        self.delegate?.didLogin()
                        

                        do {
                            try K.User.write(to: K.UserURL, atomically: true, encoding: .utf8)
                        }
                        catch{
                            print("Couldn't write to file")
                            self.passwordCriteria.isHidden = false
                        }

                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

                        
                    }
                }
                
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        performSegue(withIdentifier: K.GoToReset, sender: self)
        
    }
    
}
