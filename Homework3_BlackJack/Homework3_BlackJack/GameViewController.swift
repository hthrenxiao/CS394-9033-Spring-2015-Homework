//
//  GameViewController.swift
//  Homework3_BlackJack
//
//  Created by ZhangZhaonan on 15/3/30.
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

    
    @IBOutlet weak var ivHoleCard: UIImageView!
    @IBOutlet weak var ivDealer2ndCard: UIImageView!
    @IBOutlet weak var ivDealer3rdCard: UIImageView!
    @IBOutlet weak var ivDealer4thCard: UIImageView!
    @IBOutlet weak var ivDealer5thCard: UIImageView!
    @IBOutlet weak var lbDealerSum: UILabel!
    @IBOutlet weak var lbDealerStatus: UILabel!
    
    @IBOutlet weak var ivAI1stCard: UIImageView!
    @IBOutlet weak var ivAI2ndCard: UIImageView!
    @IBOutlet weak var ivAI3rdCard: UIImageView!
    @IBOutlet weak var ivAI4thCard: UIImageView!
    @IBOutlet weak var ivAI5thCard: UIImageView!
    @IBOutlet weak var lbAIMoney: UILabel!
    @IBOutlet weak var lbAISum: UILabel!
    @IBOutlet weak var lbAIStatus: UILabel!
    @IBOutlet weak var lbAIBet: UILabel!
    
    @IBOutlet weak var ivPlayer1stCard: UIImageView!
    @IBOutlet weak var ivPlayer2ndCard: UIImageView!
    @IBOutlet weak var ivPlayer3rdCard: UIImageView!
    @IBOutlet weak var ivPlayer4thCard: UIImageView!
    @IBOutlet weak var ivPlayer5thCard: UIImageView!
    @IBOutlet weak var lbPlayerMoney: UILabel!
    @IBOutlet weak var tfPlayerBet: UITextField!
    @IBOutlet weak var lbPlayerSum: UILabel!
    @IBOutlet weak var lbPlayerStatus: UILabel!
    @IBOutlet weak var btnHit: UIButton!
    @IBOutlet weak var btnStand: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnDeal: UIButton!
    
    var data : sharedData = sharedData.sharedInstance
    
    var currentCardPosition : Int = 0
    var gamePlayed : Int = 0
    let miniBet = 1
    
    var theShoe : Shoe = Shoe(numOfDecks: 3)
    var players : [Player] = []
    var dealerCards : [UIImageView] = []
    var AICards : [UIImageView] = []
    var playerCards : [UIImageView] = []
    
    var roundEnd = true
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dealerCards = [ivHoleCard, ivDealer2ndCard, ivDealer3rdCard, ivDealer4thCard, ivDealer5thCard]
        AICards = [ivAI1stCard, ivAI2ndCard, ivAI3rdCard, ivAI4thCard, ivAI5thCard]
        playerCards = [ivPlayer1stCard, ivPlayer2ndCard, ivPlayer3rdCard, ivPlayer4thCard, ivPlayer5thCard]
        
        theShoe = Shoe(numOfDecks: data.numOfDecks)
        theShoe.cards.shuffle()
        players.append(Player(name : "Dealer"))
        players.append(Player(name : "AI"))
        players.append(Player(name: "Player"))
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        btnDeal.enabled = true
        btnNext.enabled = false
        btnStand.enabled = false
        btnHit.enabled = false
        roundEnd = false
        
        emptyLabels(lbDealerSum, lbDealerStatus, lbAISum, lbAIStatus, lbAIBet, lbAIMoney, lbPlayerMoney, lbPlayerSum, lbPlayerStatus)
        emptyIVs(dealerCards)
        emptyIVs(AICards)
        emptyIVs(playerCards)
        
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
        
        showLabels()
    }
    
    func emptyLabels(labels : UILabel...){
        for label in labels {
            label.text?.removeAll(keepCapacity: false)
        }
    }
    
    func showLabels(){
        setMoney(lbAIMoney, lbPlayerMoney)
        setBet(tfPlayerBet, label: lbAIBet)
    }
    
    func setMoney(labels : UILabel...) {
        var index = 1
        for label in labels {
            label.text = String(players[index].money)
            index++
        }
    }
    
    func setBet(text : UITextField, label : UILabel){
        text.text = String(players[2].hands[0].bet)
        label.text = String(players[1].hands[0].bet)
    }
    
    func emptyIVs(imageViews : [UIImageView]){
        for imageView in imageViews {
            imageView.hidden = true
        }
    }
    
    func giveCards(index : Int, num : Int){
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
            updateImageViews(index)
            if index != 0 {
                switch(index){
                    case 1 :
                        lbAISum.text = String(players[index].hands[0].sum)
                    default :
                        lbPlayerSum.text = String(players[index].hands[0].sum)
                }
            }
            currentCardPosition++
        }

    }
    
    func updateImageViews(who : Int){
        
        var count = players[who].hands[0].cards.count
        switch(who){
            case 0 :
                var holeCard = UIImage(named: "pokerback")
                dealerCards[0].image = holeCard
                dealerCards[0].hidden = false
                for index in 1..<count{
                    var imageName : String = transString(players[who].hands[0].cards[index])
                    var cardImage = UIImage(named: "\(imageName)")
                    dealerCards[index].image = cardImage
                    dealerCards[index].hidden = false
                }
            case 1 :
                for index in 0..<count{
                    var imageName : String = transString(players[who].hands[0].cards[index])
                    var cardImage = UIImage(named: "\(imageName)")
                    AICards[index].image = cardImage
                    AICards[index].hidden = false
                }
            default :
                for index in 0..<count{
                    var imageName : String = transString(players[who].hands[0].cards[index])
                    var cardImage = UIImage(named: "\(imageName)")
                    playerCards[index].image = cardImage
                    playerCards[index].hidden = false
                }
        }
        
    }
    
    func transString(input : card) -> String{
        var imageName : String = ""
        switch(input.rank){
            case "A":
                imageName += "ace_of_"
            case "2":
                imageName += "2_of_"
            case "3":
                imageName += "3_of_"
            case "4":
                imageName += "4_of_"
            case "5":
                imageName += "5_of_"
            case "6":
                imageName += "6_of_"
            case "7":
                imageName += "7_of_"
            case "8":
                imageName += "8_of_"
            case "9":
                imageName += "9_of_"
            case "10":
                imageName += "10_of_"
            case "J":
                imageName += "jack_of_"
            case "Q":
                imageName += "queen_of_"
            default :
                imageName += "king_of_"
        }
        switch(input.suit){
            case "♠":
                imageName += "spades"
            case "♥":
                imageName += "hearts"
            case "♦":
                imageName += "diamonds"
            default:
                imageName += "clubs"
        }
        return imageName
    }
    
    func blackJackCheck(){
        for player in players {
            if player.hands[0].sum == 21 {
                player.hands[0].hasBJ = true
            }
        }
        
        if players[0].hands[0].hasBJ {
            lbDealerStatus.text = "BJ"
            lbDealerSum.text = String(players[0].hands[0].sum)
            var imageName : String = transString(players[0].hands[0].cards[0])
            var cardImage = UIImage(named: "\(imageName)")
            dealerCards[0].image = cardImage
            for index in 1..<players.count {
                players[index].hands[0].roundEnd = true
                if players[index].hands[0].hasBJ {
                    players[index].money += players[index].hands[0].bet
                    switch(index) {
                    case 1 :
                        lbAIMoney.text = String(players[index].money)
                        lbAIStatus.text = "BJ"
                    default :
                        lbPlayerMoney.text = String(players[index].money)
                        lbPlayerStatus.text = "BJ"
                    }
                }
                else {
                    switch(index) {
                    case 1 :
                        lbAIStatus.text = "LOSE"
                    default :
                        lbPlayerStatus.text = "LOSE"
                    }
                }
            }
            btnNext.enabled = true
        }
        else{
            for index in 1..<players.count {
                if players[index].hands[0].hasBJ {
                    players[index].hands[0].roundEnd = true
                    players[index].money += 2*players[index].hands[0].bet
                    switch(index) {
                    case 1 :
                        lbAIMoney.text = String(players[index].money)
                        lbAIStatus.text = "BJ"
                    default :
                        lbPlayerMoney.text = String(players[index].money)
                        lbPlayerStatus.text = "BJ"
                    }
                }
            }
        }
    }
    
    func continueGame(){
        if !players[2].hands[0].roundEnd && players[2].hands[0].cards.count != 5{
            btnHit.enabled = true
            btnStand.enabled = true
        }
        else{
            AITurn()
            dealerTurn()
            showResult()
            btnHit.enabled = false
            btnStand.enabled = false
            btnNext.enabled = true
        }
    }
    
    func AITurn(){
        while(!players[1].hands[0].roundEnd){
            if players[1].hands[0].cards.count == 5 {
                players[1].hands[0].roundEnd = true
            }
            else if players[1].hands[0].sum >= 17 {
                players[1].hands[0].roundEnd = true
            }
            else if players[1].hands[0].sum <= 11 {
                giveCards(1, num: 1)
                if players[1].hands[0].sum > 21 {
                    players[1].hands[0].roundEnd = true
                    players[1].hands[0].bust = true
                    lbAIStatus.text = "BUST"
                }
            }
            else{
                if players[0].hands[0].cards[1].rank == "7" || players[0].hands[0].cards[1].rank == "8" || players[0].hands[0].cards[1].rank == "9" || players[0].hands[0].cards[1].rank == "10" || players[0].hands[0].cards[1].rank == "A" || (players[1].hands[0].sum == 12 && (players[0].hands[0].cards[1].rank == "2" || players[0].hands[0].cards[1].rank == "3")) {
                    giveCards(1, num: 1)
                    if players[1].hands[0].sum > 21 {
                        players[1].hands[0].roundEnd = true
                        players[1].hands[0].bust = true
                        lbAIStatus.text = "BUST"
                    }
                }
                else{
                    players[1].hands[0].roundEnd = true
                }
            }
        }
    }
    
    func dealerTurn(){
        while players[0].hands[0].sum <= 16 && players[0].hands[0].cards.count < 5 {
            giveCards(0, num: 1)
        }
        if players[0].hands[0].sum > 21 {
            players[0].hands[0].bust = true
        }
    }
    
    func showResult(){
        lbDealerSum.text = String(players[0].hands[0].sum)
        var imageName : String = transString(players[0].hands[0].cards[0])
        var cardImage = UIImage(named: imageName)
        dealerCards[0].image = cardImage
        for index in 1..<players.count {
            if !players[index].hands[0].hasBJ {
                if !players[index].hands[0].bust {
                    if players[index].hands[0].cards.count == 5 {
                        players[index].money += 2*players[index].hands[0].bet
                        switch index {
                        case 1 :
                            lbAISum.text = "∞"
                            lbAIStatus.text = "WIN"
                            lbAIMoney.text = String(players[index].money)
                        default :
                            lbPlayerSum.text = "∞"
                            lbPlayerStatus.text = "WIN"
                            lbPlayerMoney.text = String(players[index].money)
                        }
                    }
                    else if players[0].hands[0].bust || (!players[0].hands[0].bust && players[0].hands[0].sum < players[index].hands[0].sum){
                        players[index].money += 2*players[index].hands[0].bet
                        if players[0].hands[0].bust {
                            lbDealerStatus.text = "BUST"
                        }
                        switch index {
                        case 1 :
                            lbAIStatus.text = "WIN"
                            lbAIMoney.text = String(players[index].money)
                        default :
                            lbPlayerStatus.text = "WIN"
                            lbPlayerMoney.text = String(players[index].money)
                        }
                    }
                    else if players[0].hands[0].sum > players[index].hands[0].sum {
                        switch index {
                        case 1 :
                            lbAIStatus.text = "LOSE"
                        default :
                            lbPlayerStatus.text = "LOSE"
                        }
                    }
                    else {
                        players[index].money += players[index].hands[0].bet
                        switch index {
                        case 1 :
                            lbAIStatus.text = "DRAW"
                            lbAIMoney.text = String(players[index].money)
                        default :
                            lbPlayerStatus.text = "DRAW"
                            lbPlayerMoney.text = String(players[index].money)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnDealPressed(sender: UIButton) {
        if tfPlayerBet.text.toInt() >= miniBet && tfPlayerBet.text.toInt() <= players[2].money {
            players[2].hands[0].bet = tfPlayerBet.text.toInt()!
            players[2].money -= players[2].hands[0].bet
            lbPlayerMoney.text = String(players[2].money)
            
            players[1].money -= players[1].hands[0].bet
            lbAIMoney.text = String(players[1].money)
            
            btnDeal.enabled = false
            gamePlayed++
            
            for index in 0..<players.count {
                giveCards(index, num : 2)
            }
            
            blackJackCheck()
            
            if !btnNext.enabled{
                for index in 1..<players.count {
                    if players[index].hands[0].roundEnd == false {
                        roundEnd = false
                    }
                }
                if roundEnd{
                    lbDealerSum.text = String(players[0].hands[0].sum)
                    var imageName = transString(players[0].hands[0].cards[0])
                    var cardImage = UIImage(named: imageName)
                    dealerCards[0].image = cardImage
                    btnNext.enabled = true
                }
                else{
                    continueGame()
                }
            }
        }
        else{
            let alertController = UIAlertController(title: "Warning", message: "You have to enter a valid Bet!", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnHitPressed(sender: UIButton) {
        giveCards(2, num: 1)
        if players[2].hands[0].sum > 21{
            players[2].hands[0].roundEnd = true
            players[2].hands[0].bust = true
            lbPlayerStatus.text = "BUST"
        }
        continueGame()
    }
    
    @IBAction func btnStandPressed(sender: UIButton) {
        players[2].hands[0].roundEnd = true
        continueGame()
    }
    
    @IBAction func btnNextPressed(sender: UIButton) {
        initialize()
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
