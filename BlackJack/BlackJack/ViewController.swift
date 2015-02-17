//
//  ViewController.swift
//  BlackJack
//
//  Created by ZhangZhaonan on 15/2/16.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import UIKit

extension Array{
    mutating func shuffle(){
        for i in 0..<(count-1){
            let j = Int(arc4random_uniform(UInt32(count-i))) + i
            swap(&self[i], &self[j])
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var lbCurrentScore: UILabel!
    @IBOutlet weak var tfBet: UITextField!
    
    @IBOutlet weak var btnDeal: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbInsurance: UILabel!
    @IBOutlet weak var btnInYes: UIButton!
    @IBOutlet weak var btnInNo: UIButton!
    
    @IBOutlet weak var btnStand: UIButton!
    @IBOutlet weak var btnHit: UIButton!
    @IBOutlet weak var btnDouble: UIButton!
    @IBOutlet weak var btnSurrender: UIButton!
    @IBOutlet weak var btnSplit: UIButton!
    
    @IBOutlet weak var lbPlayer: UILabel!
    @IBOutlet weak var lbPlayerSum: UILabel!
    @IBOutlet weak var lbPlayerStatus: UILabel!
    
    @IBOutlet weak var lbPlayerSlot1: UILabel!
    @IBOutlet weak var lbPlayerSlot2: UILabel!
    @IBOutlet weak var lbPlayerSlot3: UILabel!
    @IBOutlet weak var lbPlayerSlot4: UILabel!
    
    @IBOutlet weak var lbDealer: UILabel!
    @IBOutlet weak var lbDealerSum: UILabel!
    @IBOutlet weak var lbDealerStatus: UILabel!
    
    @IBOutlet weak var lbDealerSlot: UILabel!
    
    var cards = [
        "♠A","♠2","♠3","♠4","♠5","♠6","♠7","♠8","♠9","♠10","♠J","♠Q","♠K",
        "♥A","♥2","♥3","♥4","♥5","♥6","♥7","♥8","♥9","♥10","♥J","♥Q","♥K",
        "♦A","♦2","♦3","♦4","♦5","♦6","♦7","♦8","♦9","♦10","♦J","♦Q","♦J",
        "♣A","♣2","♣3","♣4","♣5","♣6","♣7","♣8","♣9","♣10","♣J","♣Q","♣K",
    ]
    
    let initialScore = 100
    let miniBet = 1
    
    var currentScore = 100
    var currentBet = 1
    
    var gamePlayed = 0
    
    var playerCards = [String]()
    var dealerCards = [String]()
    
    var currentCardPosition = 0
    var holeCard: String = ""
    
    var sideWager = 0
    
    var playerSum = 0
    var dealerSum = 0
    
    var playerBust = false
    var dealerBust = false
    
    var playerHasBJ = false
    var dealerHasBJ = false
    
    var insuranceAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cards.shuffle()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnDeal(sender: UIButton) {
        
        currentBet = tfBet.text.toInt()!
        if currentBet >= miniBet && currentBet <= currentScore {
            
            currentScore -= currentBet
            lbCurrentScore.text = String(currentScore)
            btnDeal.enabled = false
            
            gamePlayed++
            
            giveCard("player",num: 2)
            giveCard("dealer",num: 2)
            
            holeCard = dealerCards[0]
            dealerCards[0] = "??"
            
            //for card in playerCards{
            //    lbPlayerSlot1.text?.extend("\(card) ")
            //}
            for card in dealerCards{
                lbDealerSlot.text?.extend("\(card) ")
            }
            
            blackJackCheck()
            insuranceCheck()
            
        }
        else{
            let alertController = UIAlertController(title: "Warning", message: "You have to enter a valid Bet!", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnNext(sender: UIButton) {
        initialize()
    }

    @IBAction func btnInYes(sender: UIButton) {
        
        enableButtons(btnInYes, btnInNo)
        sideWager = currentBet/2
        currentScore -= sideWager
        lbCurrentScore.text = String(currentScore)
        if !dealerHasBJ {
            
            blackJackHandle()
            
        }
        else{
            currentScore += sideWager
            currentScore += currentBet
            lbCurrentScore.text = String(currentScore)
            if playerHasBJ {
                currentScore += currentBet
                lbCurrentScore.text = String(currentScore)
                btnNext.enabled = true
                enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
                showResult(0)
            }
            else{
                btnNext.enabled = true
                enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
                showResult(2)
            }
        }
        
    }
    
    @IBAction func btnInNo(sender: UIButton) {
        
        enableButtons(btnInYes, btnInNo)
        
        blackJackHandle()
        
    }
    
    @IBAction func btnStand(sender: UIButton) {
        dealersTurn()
    }
    
    @IBAction func btnHit(sender: UIButton) {
        giveCard("player", num: 1)
        if playerSum > 21{
            playerBust = true
            btnNext.enabled = true
            enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
            showResult(2)
        }
        else{
            enableButtons(btnDouble, btnSurrender, btnSplit)
        }
    }
    
    @IBAction func btnDouble(sender: UIButton) {
        currentScore -= currentBet
        lbCurrentScore.text = String(currentScore)
        currentBet *= 2
        giveCard("player", num: 1)
        if playerSum > 21{
            playerBust = true
            currentBet /= 2
            btnNext.enabled = true
            enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
            showResult(2)
        }
        else{
            dealersTurn()
            currentBet /= 2
        }
    }
    
    @IBAction func btnSurrender(sender: UIButton) {
        
        currentScore += currentBet/2
        
        lbCurrentScore.text = String(currentScore)
        
        btnNext.enabled = true
        
        enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
        
        showResult(2)
    }
    
    @IBAction func btnSplit(sender: UIButton) {
    }
    
    func initialize() {
        lbPlayerStatus.text?.removeAll(keepCapacity: false)
        lbPlayerSum.text?.removeAll(keepCapacity: false)
        
        lbDealerStatus.text?.removeAll(keepCapacity: false)
        lbDealerSum.text?.removeAll(keepCapacity: false)
        
        lbPlayerSlot1.text?.removeAll(keepCapacity: false)
        lbPlayerSlot2.text?.removeAll(keepCapacity: false)
        lbPlayerSlot3.text?.removeAll(keepCapacity: false)
        lbPlayerSlot4.text?.removeAll(keepCapacity: false)
        
        lbDealerSlot.text?.removeAll(keepCapacity: false)
        
        playerCards.removeAll(keepCapacity: false)
        dealerCards.removeAll(keepCapacity: false)
        
        holeCard = ""
        
        sideWager = 0
        
        playerSum = 0
        dealerSum = 0
        
        playerBust = false
        dealerBust = false
        
        playerHasBJ = false
        dealerHasBJ = false
        
        insuranceAvailable = false
        
        lbCurrentScore.text = String(currentScore)
        tfBet.text = String(currentBet)
        
        if gamePlayed == 5 {
            cards.shuffle()
            currentCardPosition = 0
            gamePlayed = 1
        }
        
        btnInYes.enabled = false
        btnInNo.enabled = false
        
        btnDeal.enabled = true
        btnNext.enabled = false
        btnStand.enabled = false
        btnHit.enabled = false
        btnDouble.enabled = false
        btnSurrender.enabled = false
        btnSplit.enabled = false
        
    }
    
    func giveCard (who: String, num: Int) {
        if who == "player" {
            for var i=0; i<num; i++ {
                playerCards.append(cards[currentCardPosition])
                var str: NSString = cards[currentCardPosition]
                switch str.substringFromIndex(1) {
                    case "A":
                        if playerSum + 11 <= 21 {
                            playerSum += 11
                        }
                        else{
                            playerSum += 1
                        }
                    case "2":
                        playerSum += 2
                    case "3":
                        playerSum += 3
                    case "4":
                        playerSum += 4
                    case "5":
                        playerSum += 5
                    case "6":
                        playerSum += 6
                    case "7":
                        playerSum += 7
                    case "8":
                        playerSum += 8
                    case "9":
                        playerSum += 9
                    default:
                        playerSum += 10
                    
                }
                lbPlayerSlot1.text?.extend("\(cards[currentCardPosition]) ")
                currentCardPosition++
            }
            lbPlayerSum.text = String(playerSum)
        }
        else{
            for var i=0; i<num; i++ {
                dealerCards.append(cards[currentCardPosition])
                var str: NSString = cards[currentCardPosition]
                switch str.substringFromIndex(1) {
                case "A":
                    if dealerSum + 11 <= 21 {
                        dealerSum += 11
                    }
                    else{
                        dealerSum += 1
                    }
                case "2":
                    dealerSum += 2
                case "3":
                    dealerSum += 3
                case "4":
                    dealerSum += 4
                case "5":
                    dealerSum += 5
                case "6":
                    dealerSum += 6
                case "7":
                    dealerSum += 7
                case "8":
                    dealerSum += 8
                case "9":
                    dealerSum += 9
                default:
                    dealerSum += 10
                    
                }
                //lbDealerSlot.text?.extend("\(cards[currentCardPosition-1]) ")
                currentCardPosition++
            }
        }
    }
    
    func showResult(status: Int) {
        
        lbDealerSum.text = String(dealerSum)
        lbDealerSlot.text?.removeAll(keepCapacity: false)
        dealerCards[0] = holeCard
        for card in dealerCards{
            lbDealerSlot.text?.extend("\(card) ")
        }
        
        if status == 0 {
            lbPlayerStatus.text = "DRAW"
            lbDealerStatus.text = "DRAW"
        }
        else if status == 1{
            if playerHasBJ {
                lbPlayerStatus.text = "BJ"
            }
            else{
                lbPlayerStatus.text = "WIN"
            }
            if dealerBust {
                lbDealerStatus.text = "BUST"
            }
            else{
                lbDealerStatus.text = "LOSE"
            }
        }
        else{
            if dealerHasBJ {
                lbDealerStatus.text = "BJ"
            }
            else{
                lbDealerStatus.text = "WIN"
            }
            if playerBust {
                lbPlayerStatus.text = "BUST"
            }
            else{
                lbPlayerStatus.text = "LOSE"
            }
        }
    }
    
    func enableButtons(buttons: UIButton...) {
        for button in buttons {
            button.enabled = false
        }
    }
    
    func dealersTurn(){
        if dealerSum == playerSum {
            
            currentScore += currentBet
            lbCurrentScore.text = String(currentScore)
            
            btnNext.enabled = true
            enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
            showResult(0)
        }
        else if dealerSum > playerSum{
            
            btnNext.enabled = true
            enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
            showResult(2)
            
        }
        else{
            while dealerSum < playerSum && dealerSum < 21 {
                giveCard("dealer", num: 1)
            }
            if dealerSum == playerSum {
                currentScore += currentBet
                lbCurrentScore.text = String(currentScore)
                
                btnNext.enabled = true
                enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
                showResult(0)
            }
            else if dealerSum > playerSum && dealerSum <= 21{
                
                btnNext.enabled = true
                enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
                showResult(2)
                
            }
            else{
                currentScore += 2*currentBet
                lbCurrentScore.text = String(currentScore)
                dealerBust = true
                
                btnNext.enabled = true
                enableButtons(btnStand, btnHit, btnDouble, btnSurrender, btnSplit)
                showResult(1)
            }
        }
    }
    
    func blackJackCheck(){
        if playerSum == 21{
            playerHasBJ = true
        }
        if dealerSum == 21{
            dealerHasBJ = true
        }
    }
    
    func blackJackHandle(){
        
        if playerHasBJ && dealerHasBJ {
            currentScore += currentBet
            lbCurrentScore.text = String(currentScore)
            btnNext.enabled = true
            showResult(0)
        }
        else if dealerHasBJ{
            btnNext.enabled = true
            showResult(2)
        }
        else if playerHasBJ{
            currentScore += 2*currentBet
            lbCurrentScore.text = String(currentScore)
            btnNext.enabled = true
            showResult(1)
        }
        else{
            btnStand.enabled = true
            btnHit.enabled = true
            btnDouble.enabled = true
            btnSurrender.enabled = true
        }
        
    }
    
    func insuranceCheck() {
        var str : NSString = dealerCards[1]
        if str.substringFromIndex(1) == "A" {
            insuranceAvailable = true
            btnInYes.enabled = true
            btnInNo.enabled = true
        }
        else{
            blackJackHandle()
        }
    }
}

