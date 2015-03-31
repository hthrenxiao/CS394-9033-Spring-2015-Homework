//
//  Player.swift
//  Homework3_BlackJack
//
//  Created by ZhangZhaonan on 15/3/30.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import Foundation

class Player {
    
    var name : String
    var money : Int = 100
    var hands : [Hand] = []
    
    init(name : String) {
        self.name = name
        hands.append(Hand())
    }
    
}