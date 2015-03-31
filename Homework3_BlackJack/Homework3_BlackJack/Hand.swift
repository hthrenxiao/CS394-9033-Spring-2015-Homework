//
//  Hand.swift
//  Homework3_BlackJack
//
//  Created by ZhangZhaonan on 15/3/30.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import Foundation

class Hand {
    
    var roundEnd = false
    var bust = false
    var hasBJ = false
    var cards : [card]
    var bet : Int
    var sum : Int

    init() {
        sum = 0
        cards = []
        bet = 1
    }
}