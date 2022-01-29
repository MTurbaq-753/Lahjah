//
//  UpvotedCell.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 13/01/2022.
//

import UIKit
import AVFoundation

protocol UpvotedCellDelegate{
    func ShareSheetPresent(_ v: UIActivityViewController)
}

class UpvotedCell: UITableViewCell{

    @IBOutlet weak var word: UILabel!
    
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var arabicMeaning: UILabel!
    
    @IBOutlet weak var arabicExample: UILabel!
    
    @IBOutlet weak var englishMeaning: UILabel!
    
    @IBOutlet weak var englishExample: UILabel!
   
    @IBOutlet weak var upvoteCount: UILabel!
    
    @IBOutlet weak var downvoteCount: UILabel!
    
    @IBOutlet weak var upvoteButton: UIButton!
    
    @IBOutlet weak var downvoteButton: UIButton!
    
    @IBOutlet weak var ESpeak: UIButton!
    
    @IBOutlet weak var EESpeak: UIButton!
    
    var delegate: UpvotedCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        upvoteButton.setTitle(K.currentLanguage.UpvoteButtonLabel!, for: .normal)
        downvoteButton.setTitle(K.currentLanguage.DownvoteButtonLabel!, for: .normal)
        
    }
    
    static func nib() -> UINib{
        return UINib(nibName: K.UpvotedCell, bundle: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        
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
        \(word.text! + country.text!)
        \(Meaning[K.AppCurrentLanguage]! + arabicMeaning.text!)
        \(Example[K.AppCurrentLanguage]! + arabicExample.text!)
        \(englishSentence ?? "")
        \(englishSentenceExample ?? "")
        """
        ], applicationActivities: nil)
    
        delegate?.ShareSheetPresent(shareSheetVC)
    }
    
    @IBAction func speakPressed(_ sender: UIButton) {
        let speaked: String
        let lan: String
        switch sender.accessibilityLabel {
        case "WSpeak":
            speaked = word.text!
            lan = "ar"
        case "ASpeak":
            speaked = arabicMeaning.text!
            lan = "ar"
        case "AESpeak":
            speaked = arabicExample.text!
            lan = "ar"
        case "ESpeak":
            speaked = englishMeaning.text!
            lan = "en-US"
        case "EESpeak":
            speaked = englishExample.text!
            lan = "en-US"
        default:
            speaked = "ERROR"
            lan = "en-US"
        }
        
        let utterance = AVSpeechUtterance(string: speaked)
        utterance.voice = AVSpeechSynthesisVoice(language: lan)

        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
    }
    
    
}
