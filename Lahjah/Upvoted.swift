//
//  Upvoted.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 13/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class Upvoted: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var upvotedList : [UpvotedStruct]?
    
    
    let db = Firestore.firestore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        tableView.register(UpvotedCell.nib(), forCellReuseIdentifier: K.UpvotedCell)
        tableView.dataSource = self
        tableView.delegate = self


        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upvotedList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let upvotedCell = tableView.dequeueReusableCell(withIdentifier: K.UpvotedCell, for: indexPath) as? UpvotedCell{
            
            upvotedCell.word.text = upvotedList![indexPath.item].word
            upvotedCell.arabicMeaning.text = upvotedList![indexPath.item].ArabicMeaning
            upvotedCell.arabicExample.text = upvotedList![indexPath.item].ArabicExample
            upvotedCell.englishMeaning.text = upvotedList![indexPath.item].EnglishMeaning
            upvotedCell.englishExample.text = upvotedList![indexPath.item].EnglishExample
            upvotedCell.upvoteCount.text = upvotedList![indexPath.item].upvoteCount
            upvotedCell.downvoteCount.text = upvotedList![indexPath.item].downvoteCount
            upvotedCell.upvoteButton.setImage(UIImage(systemName: K.upvoteFilled), for: .normal)
            upvotedCell.country.text = K.fromCountryToFlag[upvotedList![indexPath.item].country] ?? ""
            upvotedCell.delegate = self
            
            if upvotedCell.englishMeaning.text == "" {upvotedCell.ESpeak.isHidden = true}
            if upvotedCell.englishExample.text == ""{upvotedCell.EESpeak.isHidden = true}
            
            cell  = upvotedCell
        }
        return cell
    }
    
    func load(){

        upvotedList = []
        
        db.collection(K.ReviewDB).getDocuments{(querySnapshot, error) in if let e = error{

            print("Issue while reading, \(error)")
        }
            else{

                if let documents = querySnapshot?.documents{

                    for doc in documents{
                        if doc.documentID == K.User {
                        let data = doc.data()
                        let documentID = doc.documentID
                        for key in data.keys{

                            let rawData = data[key] as! [Any]
                            let rawKey = key
                            self.upvotedList!.append(UpvotedStruct(documentID: rawKey, word: rawData[2] as! String, ArabicMeaning: rawData[3] as! String, EnglishMeaning: rawData[5] as? String, ArabicExample: rawData[4] as! String, EnglishExample: rawData[6] as? String, upvoteCount: rawData[7] as! String, downvoteCount: rawData[8] as! String, country: rawData[9] as! String))
                            
                        }
                    }
                    }
                    
                    DispatchQueue.main.async {
            self.tableView.reloadData()
        }
                    
                }
                }

            }

            
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            decreaseVote(upvotedList![indexPath.item])
            upvotedList?.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func decreaseVote(_ data: UpvotedStruct){
        
        
        
        db.collection(K.MeaningDB).document(data.documentID!).updateData([data.word: [data.ArabicMeaning, data.EnglishMeaning, String(Int(data.upvoteCount)! - 1), data.downvoteCount, data.ArabicExample, data.EnglishExample, data.country]])
        
        db.collection(K.ReviewDB).document(K.User).updateData([data.documentID : FieldValue.delete()])
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)!

    }
    
    @IBAction func panPerformed(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension Upvoted: UpvotedCellDelegate{
    func ShareSheetPresent(_ v: UIActivityViewController) {
        if UIDevice.current.userInterfaceIdiom == .pad{
            v.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            v.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: 200, height: 200)
        }
        present(v, animated: true, completion: nil)
    }
    
    
}
//db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [true, true, word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!]])


struct UpvotedStruct{

    
    var documentID: String?
    var word: String
    var ArabicMeaning: String
    var EnglishMeaning: String?
    var ArabicExample: String
    var EnglishExample: String?
    var upvoteCount: String
    var downvoteCount: String
    var country: String
    
}
