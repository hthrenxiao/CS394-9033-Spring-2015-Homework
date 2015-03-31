//
//  ViewController.swift
//  Homework3_BlackJack
//
//  Created by ZhangZhaonan on 15/3/29.
//  Copyright (c) 2015年 ZhangZhaonan. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var CenterView: UIView!
    @IBOutlet weak var numOfDecks: UITextField!
    @IBOutlet weak var btnStartGame: UIButton!
    
    var data : sharedData = sharedData.sharedInstance
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numOfDecks.text = String(data.numOfDecks)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnStartGamePressed(sender: UIButton) {
        if numOfDecks.text.toInt() >= 3 && numOfDecks.text.toInt() <= 99 {
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

