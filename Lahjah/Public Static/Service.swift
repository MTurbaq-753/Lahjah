//
//  Service.swift
//  Lahjah
//
//  Created by Mohammad Alturbaq on 29/01/2022.
//

import UIKit


class Service: UIViewController{
    public static func popUp(_ message: String, _ error: String) -> UIAlertController{
        let popAlert = UIAlertController(title: error, message: message, preferredStyle: UIAlertController.Style.alert)
        popAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in}))
        return popAlert
    }
}
