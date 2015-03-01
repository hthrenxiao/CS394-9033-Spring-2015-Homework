//
//  ViewController.swift
//  Homework2_BlackJack
//
//  Created by ZhangZhaonan on 15/2/26.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numOfPlayers: UITextField!
    @IBOutlet weak var numOfDecks: UITextField!
    @IBOutlet weak var btnStartGame: UIButton!
    
    var data : sharedData = sharedData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numOfPlayers.text = String(data.numOfPlayers)
        numOfDecks.text = String(data.numOfDecks)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnStartGamePressed(sender: UIButton) {
        if numOfPlayers.text.toInt() <= 6 && numOfPlayers.text.toInt() >= 2 && numOfDecks.text.toInt() >= 3 && numOfDecks.text.toInt() <= 99 {
            data.numOfPlayers = numOfPlayers.text.toInt()!
            data.numOfDecks = numOfDecks.text.toInt()!
        }
        else{
            let alertController = UIAlertController(title: "Warning", message: "The numbers of the players and decks should be within the range!", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

}

