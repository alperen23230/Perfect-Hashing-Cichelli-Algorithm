//
//  ViewController.swift
//  PerfectHashingCichelliAlgorithm
//
//  Created by Alperen Ünal on 24.11.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var word1: UILabel!
    @IBOutlet weak var word2: UILabel!
    @IBOutlet weak var word3: UILabel!
    @IBOutlet weak var word4: UILabel!
    @IBOutlet weak var word5: UILabel!
    @IBOutlet weak var word6: UILabel!
    @IBOutlet weak var word7: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var labels = [UILabel]()
    
    var hashWords = [HashWord]()
    
    var charsDic: [Character : Int] = [:]
    
    var charsDic2: [Character : Int] = [:]
    
    let maxTotalCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.pushTransition(0.4)
        statusLabel.text = "Status: Now find first orders"
        // Firstly setup the words
        setupWords()
        //It will find char counts
        findCharCounts()
        
        findFirstHashOrders()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
           
            self.firstOrderForHashWords()
            
            self.statusLabel.pushTransition(0.4)
            self.statusLabel.text = "Status: Last Perfect Hashed Values"
            
            self.perfectHashingByCichelli()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.writePerfectHashValues()
            }
        }
       
        
    }

    func setupWords(){
        word1.text = "cat"
        word2.text = "ant"
        word3.text = "dog"
        word4.text = "gnat"
        word5.text = "chimp"
        word6.text = "rat"
        word7.text = "toad"
        
        labels.append(word1)
        labels.append(word2)
        labels.append(word3)
        labels.append(word4)
        labels.append(word5)
        labels.append(word6)
        labels.append(word7)
        
        let hashWord1 = HashWord(hashWord: "cat")
        let hashWord2 = HashWord(hashWord: "ant")
        let hashWord3 = HashWord(hashWord: "dog")
        let hashWord4 = HashWord(hashWord: "gnat")
        let hashWord5 = HashWord(hashWord: "chimp")
        let hashWord6 = HashWord(hashWord: "rat")
        let hashWord7 = HashWord(hashWord: "toad")
        
        hashWords.append(hashWord1)
        hashWords.append(hashWord2)
        hashWords.append(hashWord3)
        hashWords.append(hashWord4)
        hashWords.append(hashWord5)
        hashWords.append(hashWord6)
        hashWords.append(hashWord7)
    }
    

}

///MARK: Hash Functions
extension ViewController {
    func findCharCounts() {
        for hashWord in hashWords {
            charsDic2[hashWord.firstChar] = 0
            charsDic2[hashWord.lastChar] = 0
            
            if charsDic[hashWord.firstChar] != nil {
                charsDic[hashWord.firstChar]! += 1
            } else {
                charsDic[hashWord.firstChar] = 1
            }
            if charsDic[hashWord.lastChar] != nil {
                charsDic[hashWord.lastChar]! += 1
            } else {
                charsDic[hashWord.lastChar] = 1
            }
        }
    }
    
    func findFirstHashOrders(){
        for hashWord in hashWords {
            if let firstValue = charsDic[hashWord.firstChar] {
                if let lastValue = charsDic[hashWord.lastChar]{
                    hashWord.firstHashValue = firstValue + lastValue
                }
            }
        }
    }
    
    func firstOrderForHashWords(){
        hashWords = hashWords.sorted(by: { $0.firstHashValue >= $1.firstHashValue && $0.firstChar >= $1.firstChar})
        var order = 1
        for word in hashWords {
            for wordLabel in labels {
                if wordLabel.text == word.word {
                    animateLabel(with: wordLabel, order: order)
                    order += 1
                    break
                }
            }
        }
    }
    func writePerfectHashValues(){
        for word in hashWords {
            for wordLabel in labels {
                if wordLabel.text == word.word {
                    wordLabel.pushTransition(0.4)
                    wordLabel.text = "\(word.word) -> Hash Value: \(word.lastHashValue)"
                }
            }
        }
    }
    
    func perfectHashingByCichelli(){
        for hashWord in hashWords {
           setHashValue(word: hashWord)
        }
    }
    
    func setHashValue(word: HashWord){
        if charsDic2[word.firstChar] == nil {
            charsDic2[word.firstChar] = 0
        }
        if charsDic2[word.lastChar] == nil {
            charsDic2[word.lastChar] = 0
        }
        guard let firstValue = charsDic2[word.firstChar] else { return }
        guard let lastValue = charsDic2[word.lastChar] else { return }
        word.lastHashValue = firstValue + lastValue + word.wordLength
        var isUnique = controlAllHashValues(word: word)
        
        guard let firstCharValue = charsDic[word.firstChar] else { return }
        guard let lastCharValue = charsDic[word.lastChar] else { return }
        
        while !isUnique {
            if firstCharValue <= lastCharValue {
                if charsDic2[word.firstChar] != nil && charsDic2[word.firstChar]! <= maxTotalCount {
                    charsDic2[word.firstChar]! += 1
                } else {
                    if charsDic2[word.lastChar] != nil && charsDic2[word.lastChar]! <= maxTotalCount {
                        charsDic2[word.lastChar]! += 1
                    }
                }
            } else {
                if charsDic2[word.lastChar] != nil && charsDic2[word.lastChar]! <= maxTotalCount {
                    charsDic2[word.lastChar]! += 1
                } else {
                    if charsDic2[word.firstChar] != nil && charsDic2[word.firstChar]! <= maxTotalCount {
                        charsDic2[word.firstChar]! += 1
                    }
                }
            }
            
            calculateAllHashValues()
            
            isUnique = controlAllHashValues(word: word)
        }

        calculateAllHashValues()
    }
    
    func calculateAllHashValues(){
        for hashWord in hashWords {
            if let firstValue = charsDic2[hashWord.firstChar] {
                if let lastValue = charsDic2[hashWord.lastChar] {
                    hashWord.lastHashValue = firstValue + lastValue + hashWord.wordLength
                }
            }
        }
    }
    
    func controlAllHashValues(word: HashWord) -> Bool {
        var isUnique = true
        for hashWord in hashWords {
            if hashWord.word != word.word && hashWord.lastHashValue == word.lastHashValue {
                isUnique = false
            }
        }
        return isUnique
    }
}

///MARK: Animation Functions
extension ViewController {
    func animateLabel(with label: UILabel, order: Int){
        switch order {
        case 1:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 115
            })
        case 2:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 175
            })
        case 3:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 235
            })
        case 4:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 295
            })
        case 5:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 355
            })
        case 6:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 415
            })
        case 7:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [],animations: {
                label.center.y = 475
            })
        default:
            return
        }
    }
}
