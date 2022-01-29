//
//  ReusableCell.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 05/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import SQLite3
import AVFoundation

protocol ReusableCellDelegate{
    func SigninPopup()
    func ShareSheetPresent(_ v: UIActivityViewController)
}

class ReusableCell: UITableViewCell {

    @IBOutlet weak var arabicMeaning: UILabel!
    @IBOutlet weak var englishMeaning: UILabel!
    
    
    @IBOutlet weak var arabicExample: UILabel!
    
    @IBOutlet weak var englishExample: UILabel!
    
    
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    
    @IBOutlet weak var upvoteCount: UILabel!
    @IBOutlet weak var downvoteCount: UILabel!
    
    @IBOutlet weak var countryView: UILabel!
    
    @IBOutlet weak var englishSpeak: UIButton!
    
    @IBOutlet weak var englishExampleSpeak: UIButton!
    
    var delegate : ReusableCellDelegate?
    
    var word: String?
    var documentID: String?
    
    var upFlag = true
    var downFlag = true
    var count = 0
    var countryText: String?
    
    let db = Firestore.firestore()
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        upvoteButton.setTitle(K.currentLanguage.UpvoteButtonLabel, for: .normal)
        downvoteButton.setTitle(K.currentLanguage.DownvoteButtonLabel, for: .normal)
        
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib{
        return UINib(nibName: K.ReusableCell, bundle: nil)
    }
    
    
    @IBAction func ReviewPressed(_ sender: UIButton) {

        if K.User == "user"{
            
            delegate?.SigninPopup()
            return
            
        }
        
        if upFlag && downFlag{
            if sender == upvoteButton{
                generator.impactOccurred()
                upvoteCount.text = String(Int(upvoteCount.text!)! + 1)
                upvoteButton.setImage(UIImage(systemName: K.upvoteFilled), for: .normal)
                db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [false, true, word!, arabicMeaning.text!, arabicExample.text!, englishMeaning.text!, englishExample.text!, upvoteCount.text!, downvoteCount.text!, self.countryText!, K.User]]){ [self] error in
                    if let e = error{
                        
                        self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [false, true, word!, arabicMeaning.text!, arabicExample.text!, englishMeaning.text!, englishExample.text!, upvoteCount.text!, downvoteCount.text!, countryText!, K.User]])

                    }
                }
                upFlag = false
            }
            else {
                generator.impactOccurred()
                downvoteCount.text = String(Int(downvoteCount.text!)! + 1)
                downvoteButton.setImage(UIImage(systemName: K.downvoteFilled), for: .normal)
                db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [true, false, word!, arabicMeaning.text!, arabicExample.text!, englishMeaning.text!, englishExample.text!, upvoteCount.text!, downvoteCount.text!, self.countryText!, K.User]]) { error in
                    if let e = error{                    self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [true, false, self.word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]])

                    }
                }
                downFlag = false
            }
        }
        else if sender == upvoteButton && upFlag{
            upFlag = false
            downFlag = true
            generator.impactOccurred()
            upvoteCount.text = String(Int(upvoteCount.text!)! + 1)
            downvoteCount.text = String(Int(downvoteCount.text!)!-1)
            upvoteButton.setImage(UIImage(systemName: K.upvoteFilled), for: .normal)
            downvoteButton.setImage(UIImage(systemName: K.downvote), for: .normal)
            db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [false, true, word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]]) { error in
                if let e = error{                self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [false, true, self.word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]])

                }
            }
            
        }
        else if sender == downvoteButton && downFlag{
                upFlag = true
                downFlag = false
            generator.impactOccurred()
            downvoteCount.text = String(Int(downvoteCount.text!)! + 1)
            upvoteCount.text = String(Int(upvoteCount.text!)! - 1)
            downvoteButton.setImage(UIImage(systemName: K.downvoteFilled), for: .normal)
            upvoteButton.setImage(UIImage(systemName: K.upvote), for: .normal)
            db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [true, false, word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]]) { error in
                if let e = error{                self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [true, false, self.word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]])

                }
            }

            }
        else if downFlag{
            generator.impactOccurred()
            upFlag = true
            downFlag = true
            upvoteCount.text = String(Int(upvoteCount.text!)! - 1)
            upvoteButton.setImage(UIImage(systemName: K.upvote), for: .normal)
            db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [true, true, word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!]]) { error in
                if let e = error{                self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [true, true, self.word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]])

                }
            }

        }
        else if upFlag{
            generator.impactOccurred()
            upFlag = true
            downFlag = true
            downvoteCount.text = String(Int(downvoteCount.text!)! - 1)
            downvoteButton.setImage(UIImage(systemName: K.downvote), for: .normal)
            db.collection(K.ReviewDB).document(K.User).updateData([documentID!: [true, true, word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]]) { error in
                if let e = error{                self.db.collection(K.ReviewDB).document(K.User).setData([self.documentID!: [true, true, self.word!, self.arabicMeaning.text!, self.arabicExample.text!, self.englishMeaning.text!, self.englishExample.text!, self.upvoteCount.text!, self.downvoteCount.text!, self.countryText!, K.User]])

                }
            }

        }
        db.collection(K.MeaningDB).document(documentID!).setData([word!: [arabicMeaning.text, englishMeaning.text, upvoteCount.text, downvoteCount.text, arabicExample.text, englishExample.text, countryText, K.User]]) { error in

        }
        
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        
        let Meaning = ["English": "Meaning:", "Arabic": "المعنى:"]
        let Example = ["English": "Example:", "Arabic": "مثال:"]
        let MeaningEnglish: [String:String]
        let ExampleEnglish: [String:String]
        var englishSentence : String?
        var englishSentenceExample : String?
        if englishMeaning.text != nil && englishMeaning.text != ""{
            
            MeaningEnglish = ["English": "English meaning:", "Arabic": "المعنى بالانجليزية:"]
            englishSentence = MeaningEnglish[K.AppCurrentLanguage]! + englishMeaning.text!
            if englishExample.text != nil && englishExample.text != ""{
                ExampleEnglish = ["English": "English Example:", "Arabic": "مثال بالانجليزية:"]
                englishSentenceExample = ExampleEnglish[K.AppCurrentLanguage]! + englishExample.text!
            }
        }
        
        
        
        
        let shareSheetVC = UIActivityViewController(activityItems: [
        """
        \(word! + countryView.text!)
        \(Meaning[K.AppCurrentLanguage]! + arabicMeaning.text!)
        \(Example[K.AppCurrentLanguage]! + arabicExample.text!)
        \(englishSentence ?? "")
        \(englishSentenceExample ?? "")
        """
        ], applicationActivities: nil)
    
        delegate?.ShareSheetPresent(shareSheetVC)
    }
    
    @IBAction func speakPressed(_ sender: UIButton) {
        var lan : String
        let speaked: String
        switch sender.accessibilityLabel {
        case "ASpeak":
            lan = "ar"
            speaked = arabicMeaning.text!
        case "AESpeak":
            lan = "ar"
            speaked = arabicExample.text!
        case "ESpeak":
            lan = "en-US"
            speaked = englishMeaning.text!
        case "EESpeak":
            lan = "en-US"
            speaked = englishExample.text!
        default:
            lan = "en-US"
            speaked = "ERROR"
        }
        
        let utterance = AVSpeechUtterance(string: speaked)
        utterance.voice = AVSpeechSynthesisVoice(language: lan)

        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
}
