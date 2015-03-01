//
//  Hand.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
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
    /*
    {
        get {
            var temp = 0
            for card in cards {
                switch(card.rank){
                case "A":
                    if temp + 11 <= 21 {
                        temp += 11
                    }
                    else{
                        temp += 1
                    }
                case "2":
                    temp += 2
                case "3":
                    temp += 3
                case "4":
                    temp += 4
                case "5":
                    temp += 5
                case "6":
                    temp += 6
                case "7":
                    temp += 7
                case "8":
                    temp += 8
                case "9":
                    temp += 9
                default:
                    temp += 10
                }
            }
            return temp
        }
    }
    */
    init() {
        sum = 0
        cards = []
        bet = 1
    }
}