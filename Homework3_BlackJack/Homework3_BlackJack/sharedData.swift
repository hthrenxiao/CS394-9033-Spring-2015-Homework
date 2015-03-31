//
//  sharedData.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import Foundation

class sharedData {
    
    var numOfDecks : Int = 3
    var ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
    var suits = ["♠","♥","♦","♣"]
    
    class var sharedInstance : sharedData {
        
        struct s {
            static let instance : sharedData = sharedData()
        }
        return s.instance
        
    }
    
}