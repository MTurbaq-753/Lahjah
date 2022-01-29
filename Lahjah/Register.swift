//
//  Register.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 07/01/2022.
//

import UIKit
import Firebase

protocol RegisterDelegate{
    func didRegister()
}

class Register: UIViewController{
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBOutlet weak var englishEmail: UILabel!
    
    @IBOutlet weak var arabicEmail: UILabel!
    
    
    @IBOutlet weak var englishPassword: UILabel!
    
    @IBOutlet weak var arabicPassword: UILabel!
    
    @IBOutlet weak var passwordCriteria: UITextView!
        
    var userVerified = false
    var userCreated = false
    
    override func viewDidLoad() {
        
        passwordCriteria.isHidden = true
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right

        let myAttrString = NSMutableAttributedString(string: K.passwordCriteriaArabic, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.paragraphStyle: style])
        
        if K.AppCurrentLanguage == "Arabic"{
            englishEmail.isHidden = true
            englishPassword.isHidden = true
            passwordCriteria.attributedText = myAttrString
        }
        else {arabicEmail.isHidden = true
        arabicPassword.isHidden = true
        }
            
        verifyButton.setTitle(K.currentLanguage.verifyButton, for: .normal)
        registerButton.setTitle(K.currentLanguage.RegisterButton, for: .normal)
                
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if !userVerified && userCreated{
            Auth.auth().currentUser?.delete(completion: { er in
            })
        }
        
    }
    
    let passwordPattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*#?&.\_-])[A-Za-z0-9@$!#%*?&.\_-]+$"#
    
    var delegate: RegisterDelegate?
    
    
    @IBAction func verifyPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            
            if password.range(of: K.passwordPattern, options: .regularExpression) == nil{
                passwordCriteria.isHidden = false
                let popAlert = UIAlertController(title: "Error", message: "Wrong password", preferredStyle: UIAlertController.Style.alert)
                popAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in}))
                present(popAlert, animated: true, completion: nil)}
            else {
                

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                let verifySent = ["English":"Verify email", "Arabic": "تم ارسال ايميل للتوثيق"]
                if let e = error{self.present(Service.popUp(e.localizedDescription,K.currentLanguage.Error), animated: true)} else{
                    self.userCreated = true
                    let actionCodeSettings = ActionCodeSettings()
                    self.present(Service.popUp(verifySent[K.AppCurrentLanguage]!,""), animated: true)
                    self.registerButton.isHidden = false
                    Auth.auth().currentUser?.sendEmailVerification(with: actionCodeSettings, completion: { err in
                        if let e = err{print(e.localizedDescription)}
                        })
                    

                }
                
            }
            
        }
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        
            Auth.auth().currentUser?.reload(completion: { error in
            
        
        if Auth.auth().currentUser!.isEmailVerified{
            self.userVerified = true
            do {
                try K.User.write(to: K.UserURL, atomically: true, encoding: .utf8)

            }
            catch{
                self.passwordCriteria.isHidden = false
                print("Couldn't write to file")
            }
            K.User = self.emailField.text!
            self.delegate?.didRegister()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let verifySent = ["English":"Verify email", "Arabic": "الرجاء توثيق الايميل"]
            self.present(Service.popUp(verifySent[K.AppCurrentLanguage]!,""), animated: true)
        }
            })
    }
    
}
