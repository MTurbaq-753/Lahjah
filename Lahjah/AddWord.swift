//
//  AddWord.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 04/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol AddWordDelegate{
    func didSubmit()
}

class AddWord: UIViewController{

    
    var word: String?
    
    var delegate: AddWordDelegate?
    
    var chosenCountry: String?
    
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    
    @IBOutlet weak var countrySwitch: UISwitch!
    
    @IBOutlet weak var wordLabel: UITextField!
    
    
//    @IBOutlet weak var NavigationBar: UINavigationBar!
//
//    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var ArabicMeaning: UITextView!
    
    @IBOutlet weak var ArabicExample: UITextView!
    
    @IBOutlet weak var EnglishMeaning: UITextView!
    
    @IBOutlet weak var EnglishExample: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var arabicLabelEnglish: UIView!
    @IBOutlet weak var arabicLabelArabic: UIView!
    
    @IBOutlet weak var ArabicExampleEnglish: UIView!
    @IBOutlet weak var ArabicExampleArabic: UIView!
    
    @IBOutlet weak var englishLabelEnglish: UIView!
    @IBOutlet weak var englishLabelArabic: UIView!

    @IBOutlet weak var EnglishExampleEnglish: UIView!
    @IBOutlet weak var EnglishExampleArabic: UIView!
    
    
    
    @IBOutlet weak var submitButton: UIButton!
    

    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        
        K.currentLanguage = AppConfig.SystemLanguage[K.AppCurrentLanguage] as! ResultConfig
        
        submitButton.setTitle(K.currentLanguage.SubmitButton, for: .normal)
        
        
        if K.AppCurrentLanguage == "Arabic"{
            arabicLabelEnglish.isHidden = true
            ArabicExampleEnglish.isHidden = true
            englishLabelEnglish.isHidden = true
            EnglishExampleEnglish.isHidden = true
        }
        else {
            arabicLabelArabic.isHidden = true
            ArabicExampleArabic.isHidden = true
            englishLabelArabic.isHidden = true
            EnglishExampleArabic.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        
        wordLabel.delegate = self
        ArabicMeaning.delegate = self
        EnglishMeaning.delegate = self

                
        wordLabel.text = word
        

    }
    
    @IBAction func didToggleCountry(_ sender: UISwitch) {
        if sender.isOn{
            countryPicker.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.countryPicker.alpha = 1
            }
        }
        else{
            chosenCountry = ""
            UIView.animate(withDuration: 0.3, animations: {
                self.countryPicker.alpha = 0
            }) { (finished) in
                self.countryPicker.isHidden = finished
            }
        }
    }
    
    

    @IBAction func BackButtonPressed(_ sender: Any) {
//        delegate?.didSubmit()
        delegate?.didSubmit()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SubmitPressed(_ sender: Any) {
        if K.User == "user"{
            
        let popAlert = UIAlertController(title: K.currentLanguage.Error, message: K.currentLanguage.E_LoginNeeded, preferredStyle: UIAlertController.Style.alert)
                    popAlert.addAction(UIAlertAction(title: K.currentLanguage.OK, style: .default, handler: { (action: UIAlertAction!) in}))
                    present(popAlert, animated: true, completion: nil)
            return
            
        }
        
        if ArabicMeaning.text.isEmpty || wordLabel.text!.isEmpty || ArabicExample.text.isEmpty || !wordLabel.text!.partOf(K.ArabicSymbols){
            let popAlert = UIAlertController(title: K.currentLanguage.Error, message: K.currentLanguage.E_AddNeededInputs, preferredStyle: UIAlertController.Style.alert)
            popAlert.addAction(UIAlertAction(title: K.currentLanguage.OK, style: .default, handler: { (action: UIAlertAction!) in}))
            present(popAlert, animated: true, completion: nil)

            return
        }
        if EnglishExample.text != "" && EnglishMeaning.text == ""{
            let popAlert = UIAlertController(title: K.currentLanguage.Error, message: K.currentLanguage.E_EngExampleWithNoMeaning, preferredStyle: UIAlertController.Style.alert)
            popAlert.addAction(UIAlertAction(title: K.currentLanguage.OK, style: .default, handler: { (action: UIAlertAction!) in}))
            present(popAlert, animated: true, completion: nil)
            return
        }

            if let w = word{
                let temp = db.collection(K.MeaningDB).addDocument(data: [w: [ArabicMeaning.text ?? "", EnglishMeaning.text ?? "", "0", "0", ArabicExample.text ?? "", EnglishExample.text ?? "", chosenCountry ?? "", K.User]])
                delegate?.didSubmit()
                self.navigationController?.popViewController(animated: true)
                
                        
                self.db.collection(K.UserMeaningsDB).document(K.User).setData([temp.documentID: [word, ArabicMeaning.text ?? "", EnglishMeaning.text ?? "", ArabicExample.text ?? "", EnglishExample.text ?? "", chosenCountry ?? ""]], merge: true)
                
            }
        

    }
    
    
    @IBAction func panPerformed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddWord: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        word = wordLabel.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
}

extension AddWord: UITextViewDelegate{


    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == ArabicMeaning || textView == ArabicExample{
            guard CharacterSet(charactersIn: K.ArabicSymbols).isSuperset(of: CharacterSet(charactersIn: text)) else {
                
                return false
            }
            return true
        }
        if textView == EnglishMeaning || textView == EnglishExample{
            guard CharacterSet(charactersIn: K.EnglishSymbols).isSuperset(of: CharacterSet(charactersIn: text)) else {
                
                return false
            }
            return true
        }
        
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}

extension AddWord: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        K.Countries["English"]!.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {return K.currentLanguage.None}
        return K.Countries[K.AppCurrentLanguage]![row-1]+" \(K.fromCountryToFlag[K.Countries["English"]![row-1]]!)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {chosenCountry = ""}
        else{
        chosenCountry = K.Countries["English"]![row-1]
        }
    }
    
}


extension String{
    func partOf(_ symbol: String) -> Bool{
        for i in self{
            if !symbol.contains(i){
                return false
            }
        }
        return true
    }
}


