//
//  GameViewController.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
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

class GameViewController: UIViewController {
    
    @IBOutlet weak var lbCurrentPlayer: UILabel!
    @IBOutlet weak var btnDeal: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnRestart: UIButton!
    
    @IBOutlet weak var btnStand: UIButton!
    @IBOutlet weak var btnHit: UIButton!
    
    @IBOutlet weak var lbDealerCards: UILabel!
    @IBOutlet weak var lbDealerSum: UILabel!
    @IBOutlet weak var lbDealerStatus: UILabel!
    
    @IBOutlet weak var lbPlayer1Name: UILabel!
    @IBOutlet weak var lbPlayer1Cards: UILabel!
    @IBOutlet weak var lbPlayer1MoneySign: UILabel!
    @IBOutlet weak var lbPlayer1Money: UILabel!
    @IBOutlet weak var lbPlayer1BetSign: UILabel!
    @IBOutlet weak var tfPlayer1Bet: UITextField!
    @IBOutlet weak var lbPlayer1Sum: UILabel!
    @IBOutlet weak var lbPlayer1Status: UILabel!
    
    @IBOutlet weak var lbPlayer2Name: UILabel!
    @IBOutlet weak var lbPlayer2Cards: UILabel!
    @IBOutlet weak var lbPlayer2MoneySign: UILabel!
    @IBOutlet weak var lbPlayer2Money: UILabel!
    @IBOutlet weak var lbPlayer2BetSign: UILabel!
    @IBOutlet weak var tfPlayer2Bet: UITextField!
    @IBOutlet weak var lbPlayer2Sum: UILabel!
    @IBOutlet weak var lbPlayer2Status: UILabel!
    
    @IBOutlet weak var lbPlayer3Name: UILabel!
    @IBOutlet weak var lbPlayer3Cards: UILabel!
    @IBOutlet weak var lbPlayer3MoneySign: UILabel!
    @IBOutlet weak var lbPlayer3Money: UILabel!
    @IBOutlet weak var lbPlayer3BetSign: UILabel!
    @IBOutlet weak var tfPlayer3Bet: UITextField!
    @IBOutlet weak var lbPlayer3Sum: UILabel!
    @IBOutlet weak var lbPlayer3Status: UILabel!
    
    @IBOutlet weak var lbPlayer4Name: UILabel!
    @IBOutlet weak var lbPlayer4Cards: UILabel!
    @IBOutlet weak var lbPlayer4MoneySign: UILabel!
    @IBOutlet weak var lbPlayer4Money: UILabel!
    @IBOutlet weak var lbPlayer4BetSign: UILabel!
    @IBOutlet weak var tfPlayer4Bet: UITextField!
    @IBOutlet weak var lbPlayer4Sum: UILabel!
    @IBOutlet weak var lbPlayer4Status: UILabel!
    
    @IBOutlet weak var lbPlayer5Name: UILabel!
    @IBOutlet weak var lbPlayer5Cards: UILabel!
    @IBOutlet weak var lbPlayer5MoneySign: UILabel!
    @IBOutlet weak var lbPlayer5Money: UILabel!
    @IBOutlet weak var lbPlayer5BetSign: UILabel!
    @IBOutlet weak var tfPlayer5Bet: UITextField!
    @IBOutlet weak var lbPlayer5Sum: UILabel!
    @IBOutlet weak var lbPlayer5Status: UILabel!
    
    @IBOutlet weak var lbPlayer6Name: UILabel!
    @IBOutlet weak var lbPlayer6Cards: UILabel!
    @IBOutlet weak var lbPlayer6MoneySign: UILabel!
    @IBOutlet weak var lbPlayer6Money: UILabel!
    @IBOutlet weak var lbPlayer6BetSign: UILabel!
    @IBOutlet weak var tfPlayer6Bet: UITextField!
    @IBOutlet weak var lbPlayer6Sum: UILabel!
    @IBOutlet weak var lbPlayer6Status: UILabel!
    
    
    
    var data : sharedData = sharedData.sharedInstance
    
    var currentCardPosition : Int = 0
    var gamePlayed : Int = 0
    let miniBet = 1
    var currentPlayer = 1
    
    var theShoe : Shoe = Shoe(numOfDecks: 3)
    var players : [Player] = []
    var bets : [UITextField] = []
    var money : [UILabel] = []
    
    var roundEnd = true
    
    @IBAction func btnDealPressed(sender: AnyObject) {
        
        var betsLegal = true
        var index = 1
        
        for bet in bets {
            if bet.hidden == false {
                var currentBet = bet.text.toInt()!
                if currentBet >= miniBet && currentBet <= players[index].money {
                    players[index].hands[0].bet = currentBet
                }
                else{
                    betsLegal = false
                    break
                }
                index++
            }
            
        }
        
        if !betsLegal {
            let alertController = UIAlertController(title: "Warning", message: "You have to enter a valid Bet!", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            index = 0
            for player in players {
                if index == 0 {
                    index++
                    continue
                }
                else{
                    players[index].money -= players[index].hands[0].bet
                    index++
                }
            }
            index = 1
            for moneyLabel in money{
                if moneyLabel.text?.isEmpty == false {
                    moneyLabel.text = String(players[index].money)
                    index++
                }
            }
            
            btnDeal.enabled = false
            gamePlayed++
            
            for index in 0..<players.count {
                giveCards(index, num: 2)
            }
            
            index = 0
            for card in players[0].hands[0].cards {
                if index == 0 {
                    lbDealerCards.text?.extend("?? ")
                    index++
                    continue
                }
                else{
                    lbDealerCards.text?.extend("\(card.suit)\(card.rank) ")
                }
            }
         
            blackJackCheck()
            
            if !btnNext.enabled {
                for index in 1..<players.count {
                    if players[index].hands[0].roundEnd == false {
                        roundEnd = false
                    }
                }
                if roundEnd {
                    btnNext.enabled = true
                }
                else {
                    continueGame()
                }
            }
            
            
            
        }
        
    }
    
    @IBAction func btnNextPressed(sender: UIButton) {
        initialize()
    }
    
    
    @IBAction func btnStandPressed(sender: UIButton) {
        players[currentPlayer].hands[0].roundEnd = true
        continueGame()
    }
    
    
    @IBAction func btnHitPressed(sender: UIButton) {
        giveCards(currentPlayer, num: 1)
        if players[currentPlayer].hands[0].sum > 21 {
            players[currentPlayer].hands[0].roundEnd = true
            players[currentPlayer].hands[0].bust = true
            switch currentPlayer {
                case 1 :
                    lbPlayer1Status.text = "BUST"
                case 2 :
                    lbPlayer2Status.text = "BUST"
                case 3 :
                    lbPlayer3Status.text = "BUST"
                case 4 :
                    lbPlayer4Status.text = "BUST"
                case 5 :
                    lbPlayer5Status.text = "BUST"
                default :
                    lbPlayer6Status.text = "BUST"
            }
        }
        continueGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bets = [tfPlayer1Bet, tfPlayer2Bet, tfPlayer3Bet, tfPlayer4Bet, tfPlayer5Bet, tfPlayer6Bet]
        money = [lbPlayer1Money, lbPlayer2Money, lbPlayer3Money, lbPlayer4Money, lbPlayer5Money, lbPlayer6Money]
        
        theShoe = Shoe(numOfDecks: data.numOfDecks)
        theShoe.cards.shuffle()
        
        players.append(Player(name : "Dealer"))
        
        createPlayers()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize() {
        
        btnDeal.enabled = true
        btnNext.enabled = false
        btnRestart.enabled = true
        
        btnStand.enabled = false
        btnHit.enabled = false
        
        emptyLabels(lbCurrentPlayer, lbDealerCards, lbDealerSum, lbDealerStatus, lbPlayer1Cards, lbPlayer1Money, lbPlayer1Sum, lbPlayer1Status, lbPlayer2Cards, lbPlayer2Money, lbPlayer2Sum, lbPlayer2Status, lbPlayer3Cards, lbPlayer3Money, lbPlayer3Sum, lbPlayer3Status, lbPlayer4Cards, lbPlayer4Money, lbPlayer4Sum, lbPlayer4Status, lbPlayer5Cards, lbPlayer5Money, lbPlayer5Sum, lbPlayer5Status, lbPlayer6Cards, lbPlayer6Money, lbPlayer6Sum, lbPlayer6Status)
        
        if gamePlayed == 5 {
            theShoe.cards.shuffle()
            currentCardPosition = 0
            gamePlayed = 1
        }
        
        for player in players {
            player.hands[0].cards.removeAll(keepCapacity: false)
            player.hands[0].sum = 0
            player.hands[0].hasBJ = false
            player.hands[0].bust = false
            player.hands[0].roundEnd = false
        }
        
        roundEnd = true
        currentPlayer = 1
        
        showLabels()
    }
    
    func showLabels() {
        switch(data.numOfPlayers){
        case 2 :
            setNames(lbPlayer1Name, lbPlayer2Name)
            
            setMoney(lbPlayer1Money, lbPlayer2Money)
            
            setBet(tfPlayer1Bet, tfPlayer2Bet)
            
            hideLabels(lbPlayer3Name, lbPlayer3MoneySign, lbPlayer3BetSign, lbPlayer4Name, lbPlayer4MoneySign, lbPlayer4BetSign, lbPlayer5Name, lbPlayer5MoneySign, lbPlayer5BetSign, lbPlayer6Name, lbPlayer6MoneySign, lbPlayer6BetSign)
            
            hideTextfields(tfPlayer3Bet, tfPlayer4Bet, tfPlayer5Bet, tfPlayer6Bet)
        case 3 :
            setNames(lbPlayer1Name, lbPlayer2Name, lbPlayer3Name)
            
            setMoney(lbPlayer1Money, lbPlayer2Money, lbPlayer3Money)
            
            setBet(tfPlayer1Bet, tfPlayer2Bet, tfPlayer3Bet)
            
            hideLabels(lbPlayer4Name, lbPlayer4MoneySign, lbPlayer4BetSign, lbPlayer5Name, lbPlayer5MoneySign, lbPlayer5BetSign, lbPlayer6Name, lbPlayer6MoneySign, lbPlayer6BetSign)
            
            hideTextfields(tfPlayer4Bet, tfPlayer5Bet, tfPlayer6Bet)
        case 4 :
            setNames(lbPlayer1Name, lbPlayer2Name, lbPlayer3Name, lbPlayer4Name)
            
            setMoney(lbPlayer1Money, lbPlayer2Money, lbPlayer3Money, lbPlayer4Money)
            
            setBet(tfPlayer1Bet, tfPlayer2Bet, tfPlayer3Bet, tfPlayer4Bet)
            
            hideLabels(lbPlayer5Name, lbPlayer5MoneySign, lbPlayer5BetSign, lbPlayer6Name, lbPlayer6MoneySign, lbPlayer6BetSign)
            
            hideTextfields(tfPlayer5Bet, tfPlayer6Bet)
        case 5 :
            setNames(lbPlayer1Name, lbPlayer2Name, lbPlayer3Name, lbPlayer4Name, lbPlayer5Name)
            
            setMoney(lbPlayer1Money, lbPlayer2Money, lbPlayer3Money, lbPlayer4Money, lbPlayer5Money)
            
            setBet(tfPlayer1Bet, tfPlayer2Bet, tfPlayer3Bet, tfPlayer4Bet, tfPlayer5Bet)
            
            hideLabels(lbPlayer6Name, lbPlayer6MoneySign, lbPlayer6BetSign)
            
            hideTextfields(tfPlayer6Bet)
        default :
            setNames(lbPlayer1Name, lbPlayer2Name, lbPlayer3Name, lbPlayer4Name, lbPlayer5Name, lbPlayer6Name)
            
            setMoney(lbPlayer1Money, lbPlayer2Money, lbPlayer3Money, lbPlayer4Money, lbPlayer5Money, lbPlayer6Money)
            
            setBet(tfPlayer1Bet, tfPlayer2Bet, tfPlayer3Bet, tfPlayer4Bet, tfPlayer5Bet, tfPlayer6Bet)
            
            lbPlayer6Name.hidden = false
            lbPlayer6MoneySign.hidden = false
            lbPlayer6BetSign.hidden = false
            tfPlayer6Bet.hidden = false
        }
    }
    
    func createPlayers() {
        switch(data.numOfPlayers){
            case 2 :
                addPlayer("Mark", "Tom")
            case 3 :
                addPlayer("Mark", "Tom", "Jack")
            case 4 :
                addPlayer("Mark", "Tom", "Jack", "Joe")
            case 5 :
                addPlayer("Mark", "Tom", "Jack", "Joe", "Mary")
            default :
                addPlayer("Mark", "Tom", "Jack", "Joe", "Mary", "Anna")
        }
    }
    
    func addPlayer(names : String...) {
        for name in names {
            players.append(Player(name : name))
        }
    }
    
    func setNames(nameLabels : UILabel...) {
        var index = 1
        for label in nameLabels {
            label.text = "\(players[index].name): "
            index++
        }
    }
    
    func hideLabels(labels : UILabel...) {
        for label in labels {
            label.hidden = true
        }
    }
    
    func hideTextfields(texts : UITextField...){
        for text in texts {
            text.hidden = true
        }
    }
    
    func emptyLabels(labels : UILabel...){
        for label in labels {
            label.text?.removeAll(keepCapacity: false)
        }
    }
    
    func setMoney(labels : UILabel...) {
        var index = 1
        for label in labels {
            label.text = String(players[index].money)
            index++
        }
    }
    
    func setBet(texts : UITextField...){
        var index = 1
        for text in texts {
            text.text = String(players[index].hands[0].bet)
        }
    }
    
    func giveCards(index : Int, num : Int) {
        for var i=0; i<num; i++ {
            players[index].hands[0].cards.append(theShoe.cards[currentCardPosition])
            
            switch theShoe.cards[currentCardPosition].rank {
                case "A":
                    if players[index].hands[0].sum + 11 <= 21 {
                        players[index].hands[0].sum += 11
                    }
                    else{
                        players[index].hands[0].sum += 1
                    }
                case "2":
                    players[index].hands[0].sum += 2
                case "3":
                    players[index].hands[0].sum += 3
                case "4":
                    players[index].hands[0].sum += 4
                case "5":
                    players[index].hands[0].sum += 5
                case "6":
                    players[index].hands[0].sum += 6
                case "7":
                    players[index].hands[0].sum += 7
                case "8":
                    players[index].hands[0].sum += 8
                case "9":
                    players[index].hands[0].sum += 9
                default:
                    players[index].hands[0].sum += 10
            }
            
            if index != 0 {
                switch(index){
                    case 1 :
                        lbPlayer1Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer1Sum.text = String(players[index].hands[0].sum)
                    case 2 :
                        lbPlayer2Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer2Sum.text = String(players[index].hands[0].sum)
                    case 3 :
                        lbPlayer3Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer3Sum.text = String(players[index].hands[0].sum)
                    case 4 :
                        lbPlayer4Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer4Sum.text = String(players[index].hands[0].sum)
                    case 5 :
                        lbPlayer5Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer5Sum.text = String(players[index].hands[0].sum)
                    default :
                        lbPlayer6Cards.text?.extend("\(theShoe.cards[currentCardPosition].suit)\(theShoe.cards[currentCardPosition].rank) ")
                        lbPlayer6Sum.text = String(players[index].hands[0].sum)
                }
            }
            currentCardPosition++
        }
    }
    
    func blackJackCheck() {
        for player in players {
            if player.hands[0].sum == 21 {
                player.hands[0].hasBJ = true
            }
        }
        
        if players[0].hands[0].hasBJ {
            
            lbDealerStatus.text = "BJ"
            lbDealerSum.text = String(players[0].hands[0].sum)
            lbDealerCards.text?.removeAll(keepCapacity: false)
            for card in players[0].hands[0].cards {
                lbDealerCards.text?.extend("\(card.suit)\(card.rank) ")
            }
            
            for index in 1..<players.count {
                players[index].hands[0].roundEnd = true
                if players[index].hands[0].hasBJ {
                    players[index].money += players[index].hands[0].bet
                    switch(index) {
                        case 1 :
                            lbPlayer1Money.text = String(players[index].money)
                            lbPlayer1Status.text = "BJ"
                        case 2 :
                            lbPlayer2Money.text = String(players[index].money)
                            lbPlayer2Status.text = "BJ"
                        case 3 :
                            lbPlayer3Money.text = String(players[index].money)
                            lbPlayer3Status.text = "BJ"
                        case 4 :
                            lbPlayer4Money.text = String(players[index].money)
                            lbPlayer4Status.text = "BJ"
                        case 5 :
                            lbPlayer5Money.text = String(players[index].money)
                            lbPlayer5Status.text = "BJ"
                        default :
                            lbPlayer6Money.text = String(players[index].money)
                            lbPlayer6Status.text = "BJ"
                    }
                }
                else {
                    switch(index) {
                        case 1 :
                            lbPlayer1Status.text = "LOSE"
                        case 2 :
                            lbPlayer2Status.text = "LOSE"
                        case 3 :
                            lbPlayer3Status.text = "LOSE"
                        case 4 :
                            lbPlayer4Status.text = "LOSE"
                        case 5 :
                            lbPlayer5Status.text = "LOSE"
                        default :
                            lbPlayer6Status.text = "LOSE"
                    }
                }
            }
            btnNext.enabled = true
        }
        else {
            for index in 1..<players.count {
                if players[index].hands[0].hasBJ {
                    players[index].hands[0].roundEnd = true
                    players[index].money += 2*players[index].hands[0].bet
                    switch(index) {
                        case 1 :
                            lbPlayer1Money.text = String(players[index].money)
                            lbPlayer1Status.text = "BJ"
                        case 2 :
                            lbPlayer2Money.text = String(players[index].money)
                            lbPlayer2Status.text = "BJ"
                        case 3 :
                            lbPlayer3Money.text = String(players[index].money)
                            lbPlayer3Status.text = "BJ"
                        case 4 :
                            lbPlayer4Money.text = String(players[index].money)
                            lbPlayer4Status.text = "BJ"
                        case 5 :
                            lbPlayer5Money.text = String(players[index].money)
                            lbPlayer5Status.text = "BJ"
                        default :
                            lbPlayer6Money.text = String(players[index].money)
                            lbPlayer6Status.text = "BJ"
                    }
                }
            }
        }
    }
    
    func continueGame() {
        var count = 0
        
        for index in 1..<players.count {
            if players[index].hands[0].roundEnd {
                count++
            }
        }
        
        if count == players.count-1 {
            roundEnd = true
        }
        else {
            roundEnd = false
        }
        
        if !roundEnd {
            for index in 1..<players.count {
                if !players[index].hands[0].roundEnd {
                    currentPlayer = index
                    lbCurrentPlayer.text = players[index].name
                    btnHit.enabled = true
                    btnStand.enabled = true
                    break;
                }
            }
        }
        else {
            dealerTurn()
            showResult()
            btnHit.enabled = false
            btnStand.enabled = false
            btnNext.enabled = true
        }
    }
    
    func dealerTurn() {
        while players[0].hands[0].sum <= 16 {
            giveCards(0, num: 1)
        }
        
        if players[0].hands[0].sum > 21 {
            players[0].hands[0].bust = true
        }
    }
    
    func showResult() {
        lbDealerSum.text = String(players[0].hands[0].sum)
        lbDealerCards.text?.removeAll(keepCapacity: false)
        for card in players[0].hands[0].cards {
            lbDealerCards.text?.extend("\(card.suit)\(card.rank) ")
        }
        
        for index in 1..<players.count {
            if !players[index].hands[0].hasBJ {
                if !players[index].hands[0].bust {
                    if players[0].hands[0].bust || (!players[0].hands[0].bust && players[0].hands[0].sum < players[index].hands[0].sum){
                        players[index].money += 2*players[index].hands[0].bet
                        switch index {
                        case 1 :
                            lbPlayer1Status.text = "WIN"
                            lbPlayer1Money.text = String(players[index].money)
                        case 2 :
                            lbPlayer2Status.text = "WIN"
                            lbPlayer2Money.text = String(players[index].money)
                        case 3 :
                            lbPlayer3Status.text = "WIN"
                            lbPlayer3Money.text = String(players[index].money)
                        case 4 :
                            lbPlayer4Status.text = "WIN"
                            lbPlayer4Money.text = String(players[index].money)
                        case 5 :
                            lbPlayer5Status.text = "WIN"
                            lbPlayer5Money.text = String(players[index].money)
                        default :
                            lbPlayer6Status.text = "WIN"
                            lbPlayer6Money.text = String(players[index].money)
                        }
                    }
                    else if players[0].hands[0].sum > players[index].hands[0].sum {
                        switch index {
                        case 1 :
                            lbPlayer1Status.text = "LOSE"
                        case 2 :
                            lbPlayer2Status.text = "LOSE"
                        case 3 :
                            lbPlayer3Status.text = "LOSE"
                        case 4 :
                            lbPlayer4Status.text = "LOSE"
                        case 5 :
                            lbPlayer5Status.text = "LOSE"
                        default :
                            lbPlayer6Status.text = "LOSE"
                        }
                    }
                    else {
                        players[index].money += players[index].hands[0].bet
                        switch index {
                        case 1 :
                            lbPlayer1Status.text = "DRAW"
                            lbPlayer1Money.text = String(players[index].money)
                        case 2 :
                            lbPlayer2Status.text = "DRAW"
                            lbPlayer2Money.text = String(players[index].money)
                        case 3 :
                            lbPlayer3Status.text = "DRAW"
                            lbPlayer3Money.text = String(players[index].money)
                        case 4 :
                            lbPlayer4Status.text = "DRAW"
                            lbPlayer4Money.text = String(players[index].money)
                        case 5 :
                            lbPlayer5Status.text = "DRAW"
                            lbPlayer5Money.text = String(players[index].money)
                        default :
                            lbPlayer6Status.text = "DRAW"
                            lbPlayer6Money.text = String(players[index].money)
                        }
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
