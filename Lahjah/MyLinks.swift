//
//  MyLinks.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 13/01/2022.
//

import UIKit

class MyLinks: UIViewController{
    
    
    @IBOutlet var labels: [UILabel]!
    
    override func viewDidLoad() {
        if K.AppCurrentLanguage == "Arabic"{
            labels[0].text = "شيّك على حساب الآب ستور!"
            labels[1].text = "تابعني على تويتر"
            labels[2].text = "قيت هب (Github)"
            labels[3].text = "ايميل التواصل"
        }
    }
    
    @IBAction func appstoreClicked(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/lahjah/id1607681695") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func twitterClicked(_ sender: Any) {
        if let url = URL(string: "https://twitter.com/MTurbaq_753") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func githubClicked(_ sender: Any) {
        if let url = URL(string: "https://github.com/MTurbaq-753") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func emailClicked(_ sender: Any) {
        let email = "MTurbaq.753@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
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
