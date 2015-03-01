//
//  Shoe.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import Foundation

class Shoe {
    
    var data : sharedData = sharedData.sharedInstance
    var decks : deck = deck()
    
    var numOfDecks : Int
    var cards : [card]
    
    init(numOfDecks : Int ){
        
        self.cards = []
        
        self.numOfDecks = data.numOfDecks
        
        for num in 0..<numOfDecks {
            cards += decks.cards
        }
    }
    
}