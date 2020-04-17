//
//  HashWord.swift
//  PerfectHashingCichelliAlgorithm
//
//  Created by Alperen Ünal on 24.11.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

class HashWord {
    var word: String
    var firstChar: Character
    var lastChar: Character
    var wordLength: Int
    var firstHashValue: Int = 0
    var lastHashValue: Int = 0
    
    init(hashWord: String){
        self.word = hashWord
        self.firstChar = hashWord.first!
        self.lastChar = hashWord.last!
        self.wordLength = hashWord.count
    }
}
