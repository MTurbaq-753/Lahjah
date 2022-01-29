//
//  Added Meanings.swift
//  Lahjah
//
//  Created by Mohammad Alturbaq on 28/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddedMeanings: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var addedList: [AddedMeaningStruct]?
    
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        
        load()
        
        tableView.register(AddedMeaningCell.nib(), forCellReuseIdentifier: K.AddedMeaningCell)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let addedCell = tableView.dequeueReusableCell(withIdentifier: K.AddedMeaningCell, for: indexPath) as? AddedMeaningCell{
            
            addedCell.word.text = addedList![indexPath.item].word
            addedCell.arabicMeaning.text = addedList![indexPath.item].ArabicMeaning
            addedCell.arabicExample.text = addedList![indexPath.item].ArabicExample
            addedCell.englishMeaning.text = addedList![indexPath.item].EnglishMeaning
            addedCell.englishExample.text = addedList![indexPath.item].EnglishExample
            addedCell.country.text = K.fromCountryToFlag[addedList![indexPath.item].country]
            addedCell.countryText.text = K.countryDictionary[K.AppCurrentLanguage]![addedList![indexPath.item].country]
            
            addedCell.delegate = self
            
            cell = addedCell
        }
    return cell
    }
    
    func load(){
        
        addedList = []
        
        db.collection(K.UserMeaningsDB).getDocuments{(querySnapshot, error) in if let e = error{

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
                            self.addedList!.append(AddedMeaningStruct(documentID: rawKey, word: rawData[0] as! String, ArabicMeaning: rawData[1] as! String, EnglishMeaning: rawData[2] as! String, ArabicExample: rawData[3] as! String, EnglishExample: rawData[4] as! String, country: rawData[5] as! String))
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)!

    }
    
    @IBAction func panPerformed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)!

    }
}

extension AddedMeanings: AddedMeaningCellDelegate{
    func ShareSheetPresent(_ v: UIActivityViewController) {
        if UIDevice.current.userInterfaceIdiom == .pad{
            v.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            v.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: 200, height: 200)
        }
        present(v, animated: true, completion: nil)
    }
    
    
}


struct AddedMeaningStruct{
    var documentID: String?
    var word: String
    var ArabicMeaning: String
    var EnglishMeaning: String?
    var ArabicExample: String
    var EnglishExample: String?
    var country: String
}
