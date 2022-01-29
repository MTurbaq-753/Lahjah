//
//  ResetPassword.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 13/01/2022.
//

import UIKit
import Firebase

class ResetPassword: UIViewController{
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var verificationButton: UIButton!
    
    @IBOutlet weak var emailArabic: UILabel!
    
    @IBOutlet weak var emailEnglish: UILabel!

    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        if K.AppCurrentLanguage == "Arabic"{
            
            forgotPasswordLabel.text = "نسيت كلمة المرور"
            
            let title = NSAttributedString(string: "إرسال رمز التفعيل")
            verificationButton.setAttributedTitle(title, for: .normal)
            emailEnglish.isHidden = true
            
        }
        else {emailArabic.isHidden = true
        }
    }
    
    
    @IBAction func verificationPressed(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailField.text!) { error in
            if let e = error{print(e.localizedDescription)
                let popAlert = UIAlertController(title: K.currentLanguage.Error, message: K.currentLanguage.E_WrongEmail, preferredStyle: UIAlertController.Style.alert)
                popAlert.addAction(UIAlertAction(title: K.currentLanguage.OK, style: .default, handler: { (action: UIAlertAction!) in}))
                self.present(popAlert, animated: true, completion: nil)
            }
            else{
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)!

    }
    
    @IBAction func panPerformed(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
