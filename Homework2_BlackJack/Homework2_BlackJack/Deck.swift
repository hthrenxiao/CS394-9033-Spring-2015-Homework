//
//  Deck.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import Foundation

class deck {
    
    var data : sharedData = sharedData.sharedInstance
    
    var cards : [card]
    
    init(){
        
        self.cards = []
        
        for suit in data.suits {
            for  rank in data.ranks {
                self.cards.append(card(rank: rank, suit: suit))
            }
        }
    }
    
}