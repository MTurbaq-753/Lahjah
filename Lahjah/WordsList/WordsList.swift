//
//  CollectionViewController.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 26/12/2021.
//

import UIKit
import Firebase
import FirebaseFirestore


class WordsList: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var flag = true

    var val : String?
    var sorted : [String]?
    
    var data: MyData?
    
    let db = Firestore.firestore()
    
    var results: [String] = []
    
    var dic: [String: [Meanings]] = [:]

    var pressedMeaning: String?
    
    var pressedResult: [String]?
    

    @IBOutlet weak var cView: UICollectionView!
    @IBOutlet weak var AddWordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = MyData(val!, results)
        DispatchQueue.main.async {
            self.load()

        }
        
        self.sorted = self.data!.sort(text: self.val!)
                
        
        cView.register(WordsCell.nib(), forCellWithReuseIdentifier: K.WordsCell)
        
        cView.delegate = self
        cView.dataSource = self
        
        AddWordButton.setTitle(K.currentLanguage.AddWordButton!, for: .normal)

    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sorted!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.WordsCell, for: indexPath) as? WordsCell{

            wordCell.configure(sorted![indexPath.row])
            
            cell = wordCell
            wordCell.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            wordCell.layer.borderWidth = 5

        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cView.cellForItem(at: indexPath) as? WordsCell
        pressedMeaning = cell?.label.text

            
            performSegue(withIdentifier: K.GoToMeaning, sender: self)
        
    }
    
    //MARK: - Important comment
    //You can check the first letter of user's input and compare it to the given rawData, if they match, add that data to your array, do that if there's a lot of words and you need to limit the local array's values
    
    //MARK: - Load
    func load(){
        results = []
        
        db.collection(K.MeaningDB).getDocuments{(querySnapshot, error) in if let e = error{
            print("Issue while reading, \(e)")
        }
            else{
                if let documents = querySnapshot?.documents{
                    for doc in documents{
                        let data = doc.data()
                        let documentID = doc.documentID
                for key in data.keys{
                    
                    let rawData = data[key] as! Array<String>
                    let rawKey = key

                    if self.dic[rawKey] != nil{
                            var temp = self.dic[rawKey]
                        temp?.append(Meanings(documentID: documentID, word: rawKey, ArabicMeaning: rawData[0], EnglishMeaning: rawData[1], ArabicExample: rawData[4], EnglishExample: rawData[5], upvoteCount: Int(rawData[2])!, downvoteCount: Int(rawData[3])!,
                            country: rawData[6]))
                        
                            self.dic[rawKey] = temp
                        }
                        else {
                            
                            self.dic[rawKey] = [ (Meanings(documentID: documentID, word: rawKey, ArabicMeaning: rawData[0], EnglishMeaning: rawData[1], ArabicExample: rawData[4], EnglishExample: rawData[5], upvoteCount: Int(rawData[2])!, downvoteCount: Int(rawData[3])!,
                                country: rawData[6]))
                                                 ]
                        }
                    
                    
                    
                    

                                
                    if !self.results.contains(rawKey){
                    self.results.append(rawKey)
                    }
                }
                                            }
                    
                    
                    DispatchQueue.main.async {
                        self.data?.results = self.results
                        self.sorted = self.data?.sort(text: self.val!)
                        self.cView.reloadData()
                                            }
                }

            }
            
            

            
            
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)!

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.GoToAddWord{
            let destinationVC = segue.destination as! AddWord
            destinationVC.delegate = self

        }
        else if segue.identifier == K.GoToMeaning{
            let destinationVC = segue.destination as! MeaningResults
            destinationVC.delegate = self
            destinationVC.word = pressedMeaning
            destinationVC.meanings = dic[pressedMeaning!]
        }
    }

    @IBAction func panPerformed(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

struct Meanings: Comparable{
    static func < (lhs: Meanings, rhs: Meanings) -> Bool {
        return lhs.upvoteCount > rhs.upvoteCount
    }
    
    var documentID: String?
    var word: String
    var ArabicMeaning: String
    var EnglishMeaning: String?
    var ArabicExample: String
    var EnglishExample: String?
    var upvoteCount: Int
    var downvoteCount: Int
    var country: String?

}



extension WordsList: AddWordDelegate{
    func didSubmit() {
        DispatchQueue.main.async {
            self.dic = [:]
            self.load()
            self.cView.reloadData()
        }
    }
}


extension WordsList: MeaningResultsDelegate{
    func didDismiss() {
        DispatchQueue.main.async {
            self.dic = [:]
            self.load()
            self.cView.reloadData()
        }
    }
}

extension UIPanGestureRecognizer {

    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        static let Up = PanGestureDirection(rawValue: 1 << 0)
        static let Down = PanGestureDirection(rawValue: 1 << 1)
        static let Left = PanGestureDirection(rawValue: 1 << 2)
        static let Right = PanGestureDirection(rawValue: 1 << 3)
    }

    private func getDirectionBy(velocity: CGFloat, greater: PanGestureDirection, lower: PanGestureDirection) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }

    public func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(velocity: velocity.y, greater: PanGestureDirection.Down, lower: PanGestureDirection.Up)
        let xDirection = getDirectionBy(velocity: velocity.x, greater: PanGestureDirection.Right, lower: PanGestureDirection.Left)
        return xDirection.union(yDirection)
    }
}

