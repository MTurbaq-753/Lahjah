//
//  MeaningResults.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 05/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

protocol MeaningResultsDelegate{
    func didDismiss()
}

class MeaningResults: UIViewController, UITableViewDelegate{
    func SigninPopup() {
        let popAlert = UIAlertController(title: K.currentLanguage.Error, message: K.currentLanguage.E_LoginNeeded, preferredStyle: UIAlertController.Style.alert)
                    popAlert.addAction(UIAlertAction(title: K.currentLanguage.OK, style: .default, handler: { (action: UIAlertAction!) in}))
                    present(popAlert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var Word: UILabel!
    @IBOutlet weak var englishLetters: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var word: String?
    var meanings: [Meanings]?
    var delegate: MeaningResultsDelegate?
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Word.text = word
        englishLetters.text = ArToEng()
        tableView.register(ReusableCell.nib(), forCellReuseIdentifier: K.ReusableCell)
        tableView.dataSource = self
        tableView.delegate = self
        DispatchQueue.main.async {
            self.meanings?.sort()
        }
        
//        ArabicView.addBottomBorderWithColor(color: .green, width: 1)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        


//        func super.viewDidDisappear(animated){
//
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.delegate?.didDismiss()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func ArToEng() -> String{
        var temp = "\""
        for i in word!{
            if let d = K.ArToEn["\(i)"]{
                temp.append(d)
            }
            else{
                if let d = K.ArToEn[K.ArabicLettersCombined["\(i)"]!]{
                    temp.append(d)
                }
                }
            }
        return "\(temp)\""
    }
    
    @IBAction func speakPressed(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: word!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ar")

        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
}



extension MeaningResults: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meanings?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let meaningCell = tableView.dequeueReusableCell(withIdentifier: K.ReusableCell, for: indexPath) as? ReusableCell{
            
            meaningCell.arabicMeaning.text! = meanings![indexPath.row].ArabicMeaning
            meaningCell.englishMeaning.text! = meanings![indexPath.row].EnglishMeaning ?? ""
            meaningCell.arabicExample.text! = meanings![indexPath.row].ArabicExample
            meaningCell.englishExample.text = meanings![indexPath.row].EnglishExample ?? ""
            meaningCell.upvoteCount.text! = String(meanings![indexPath.row].upvoteCount)
            meaningCell.downvoteCount.text! = String(meanings![indexPath.row].downvoteCount)
            
            meaningCell.word = meanings![indexPath.row].word
            meaningCell.documentID = meanings![indexPath.row].documentID
            meaningCell.countryText = meanings![indexPath.row].country ?? ""
            meaningCell.countryView.text! = K.fromCountryToFlag[meanings![indexPath.row].country ?? ""] ?? ""
            meaningCell.delegate = self
            print(meaningCell.englishMeaning.text)
            if meaningCell.englishMeaning.text == ""{
                meaningCell.englishSpeak.isHidden = true

            }
            if meaningCell.englishExample.text == ""{meaningCell.englishExampleSpeak.isHidden = true}
            
            db.collection(K.ReviewDB).getDocuments{( querySnapshot, error) in
                if let e = error{print("LINE 89:", e.localizedDescription)} else{

                    if let documents = querySnapshot?.documents{

                        for doc in documents{

                            if K.User == doc.documentID{
                                let data = doc.data()
                            if let rawData = data[self.meanings![indexPath.row].documentID!] as! Array<Any>?
                            {
                                meaningCell.upFlag = rawData[0] as! Bool
                                meaningCell.downFlag = rawData[1] as! Bool
                                
                                if meaningCell.upFlag && meaningCell.downFlag{
                                    meaningCell.upvoteButton.setImage(UIImage(systemName: K.upvote), for: .normal)
                                    meaningCell.downvoteButton.setImage(UIImage(systemName: K.downvote), for: .normal)
                                }
                                else {
                                
                                if meaningCell.downFlag{
                                    meaningCell.upvoteButton.setImage(UIImage(systemName: K.upvoteFilled), for: .normal)
                                    meaningCell.downvoteButton.setImage(UIImage(systemName: K.downvote), for: .normal)
                                }
                                else if meaningCell.upFlag{
                                    meaningCell.downvoteButton.setImage(UIImage(systemName: K.downvoteFilled), for: .normal)
                                    meaningCell.upvoteButton.setImage(UIImage(systemName: K.upvote), for: .normal)
                                }
                            }
                            
                        }
                        }
                        }
                    }
   
                }
            }
            
            
            
            cell = meaningCell
        }
        return cell
        
    }
    
    func createNewReview(_ indexPath: IndexPath, _ meaningCell: ReusableCell){
        db.collection(K.ReviewDB).getDocuments{( querySnapshot, error) in
            if let e = error{print(e)} else{
                
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        print(K.User, doc.documentID)
                        if K.User == doc.documentID{
                            let data = doc.data()
                        if let rawData = data[self.meanings![indexPath.row].documentID!] as! Array<Any>?
                        {
                            meaningCell.upFlag = rawData[0] as! Bool
                            meaningCell.downFlag = rawData[1] as! Bool
                            
                            if meaningCell.downFlag{
                                meaningCell.upvoteButton.setImage(UIImage(systemName: K.upvoteFilled), for: .normal)
                                meaningCell.downvoteButton.setImage(UIImage(systemName: K.downvote), for: .normal)
                            }
                            else if meaningCell.upFlag{
                                meaningCell.downvoteButton.setImage(UIImage(systemName: K.downvoteFilled), for: .normal)
                                meaningCell.upvoteButton.setImage(UIImage(systemName: K.upvote), for: .normal)
                            }
                        
                    }
                    }
                    }
                }

            }
        }
    
    
    }
}


extension MeaningResults: ReusableCellDelegate{
    func ShareSheetPresent(_ v: UIActivityViewController) {

        if UIDevice.current.userInterfaceIdiom == .pad{
            v.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            v.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: 200, height: 200)
        }
        present(v, animated: true, completion: nil)
    }
    
    
    
    
}
