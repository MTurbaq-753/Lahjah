//
//  data.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 26/12/2021.
//

//"ياكل", "كمبيوتر", "يطرطع", "يزبن", "مستفز", "طبطبة", "زول", "خوش"

import Foundation
import Firebase
import SwiftyStringScore

class MyData{
    
    let db = Firestore.firestore()
    
    init(_ val: String, _ data: [String]){
    }
    
    var results :[String] = []
    
    
    
    
    func sort(text: String) -> [String]{
        
        var temp : [String] = []
        for i in results{
            
            if text.partOf(i){
                temp.append(i)
            }

        }
        return temp

    }
    
//    func load(){
//        results = []
//
//        db.collection(K.MeaningDB).getDocuments{(querySnapshot, error) in if let e = error{
//            print("Issue while reading, \(error)")
//        }
//            else{
//                if let documents = querySnapshot?.documents{
//                    for doc in documents{
//                        let data = doc.data()
//
//                for key in data.keys{
//
//                    let rawData = data[key] as! Array<Any>
//                    let rawKey = key as! String
//                    if !self.results.contains(rawKey){
//                    self.results.append(rawKey)
//                    }
//
//
//
//                }
//                    }
//                }
//            }
//            print(self.results)
//
//
//
//
//
//        }
//    }
}
