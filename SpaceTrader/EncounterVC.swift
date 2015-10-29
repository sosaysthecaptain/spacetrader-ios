//
//  EncounterVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 10/10/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import UIKit

class EncounterVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerShipType.text = player.commanderShip.name
        playerHull.text = "Hull at \(player.commanderShip.hullPercentage)%"
        playerShields.text = player.getShieldStrengthString(player.commanderShip)
        opponentShipType.text = galaxy.currentJourney!.currentEncounter!.opponent.ship.name
        opponentHull.text = "Hull at \(galaxy.currentJourney!.currentEncounter!.opponent.ship.hullPercentage)%"
        opponentShields.text = player.getShieldStrengthString(galaxy.currentJourney!.currentEncounter!.opponent.ship)
        
        // if encounterText1 not otherwise set, display first context information. Else, display it
        if galaxy.currentJourney!.currentEncounter!.encounterText1 == "" {
            firstTextBlock.text = "At \(galaxy.currentJourney!.clicks) clicks from \(galaxy.targetSystem!.name) you encounter a \(galaxy.currentJourney!.currentEncounter!.opponent.ship.IFFStatus.rawValue) \(galaxy.currentJourney!.currentEncounter!.opponent.ship.name)."
        } else {
            firstTextBlock.text = galaxy.currentJourney!.currentEncounter!.encounterText1
        }
        
        //firstTextBlock.text = galaxy.currentJourney!.currentEncounter!.encounterText1
        secondTextBlock.text = galaxy.currentJourney!.currentEncounter!.encounterText2
        
        let controlState = UIControlState()
        button1Text.setTitle("\(galaxy.currentJourney!.currentEncounter!.button1Text)", forState: controlState)
        button2Text.setTitle("\(galaxy.currentJourney!.currentEncounter!.button2Text)", forState: controlState)
        button3Text.setTitle("\(galaxy.currentJourney!.currentEncounter!.button3Text)", forState: controlState)
        button4Text.setTitle("\(galaxy.currentJourney!.currentEncounter!.button4Text)", forState: controlState)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageHandler:", name: "encounterNotification", object: nil)
    }

    
    @IBOutlet weak var playerShipType: UILabel!
    @IBOutlet weak var playerHull: UILabel!
    @IBOutlet weak var playerShields: UILabel!
    @IBOutlet weak var opponentShipType: UILabel!
    @IBOutlet weak var opponentHull: UILabel!
    @IBOutlet weak var opponentShields: UILabel!
    
    
    @IBOutlet weak var firstTextBlock: UITextView!
    @IBOutlet weak var secondTextBlock: UITextView!


    @IBOutlet weak var button1Text: UIButton!
    @IBOutlet weak var button2Text: UIButton!
    @IBOutlet weak var button3Text: UIButton!
    @IBOutlet weak var button4Text: UIButton!
    
    // BUTTON FUNCTIONS***************************************************************************
    @IBAction func button1(sender: AnyObject) {
        let button1Text = galaxy.currentJourney!.currentEncounter!.button1Text
        if button1Text == "Attack" {
            print("attack pressed")
        } else if button1Text == "Board" {
            print("board pressed")
        }
    }
    
    @IBAction func button2(sender: AnyObject) {
        let button2Text = galaxy.currentJourney!.currentEncounter!.button2Text
        if button2Text == "Flee" {
            print("flee pressed")
        } else if button2Text == "Plunder" {
            print("plunder pressed")
        } else if button2Text == "Ignore" {
            print("ignore pressed")
        }
    }
    
    @IBAction func button3(sender: AnyObject) {
        let button3Text = galaxy.currentJourney!.currentEncounter!.button3Text
        if button3Text == "Surrender" {
            print("surrender pressed")
        } else if button3Text == "Submit" {
            print("submit pressed")
        } else if button3Text == "Yield" {
            print("yield pressed")
        } else if button3Text == "Trade" {
            print("trade pressed")
        } else if button3Text == "" {
            // Not a button. Do nothing.
        }
    }
    
    @IBAction func button4(sender: AnyObject) {
        let button4Text = galaxy.currentJourney!.currentEncounter!.button4Text
        if button4Text == "Bribe" {
            print("bribe pressed")
        } else if button4Text == "" {
            // do nothing
        }
    }


    
    // END BUTTON FUNCTIONS***********************************************************************
    
    func messageHandler(notification: NSNotification) {
        let receivedMessage: String = notification.object! as! String
        
        if receivedMessage == "playerKilled" {
            gameOverModal()
        } else if receivedMessage == "dismissViewController" {
            dismissViewController()
        } else if receivedMessage == "simple" {
            launchGenericSimpleModal()
        } else if receivedMessage == "pirateDestroyed" {
            let statusType: IFFStatusType = galaxy.currentJourney!.currentEncounter!.opponent.ship.IFFStatus
            pirateOrTraderDestroyedAlert(statusType)
        } else if receivedMessage == "dismiss" {
            dismissViewController()
        } else if receivedMessage == "submit" {
            submit()
        }
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func fireAttackWarningModal(type: String) {
        var title: String = "Attack Police?"
        var message: String = "Are you sure you want to attack the police? Your police record will be set to criminal!"
        if type == "trader" {
            title = "Attack Trader?"
            message = "Are you sure you want to attack a trader? Your police record will be set to dubious!"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Attack", style: UIAlertActionStyle.Destructive,handler: {
            (alert: UIAlertAction!) -> Void in
            // go ahead with it
            if type == "police" {
                player.policeRecord = PoliceRecordType.criminalScore
            } else if type == "trader" {
                player.policeRecord = PoliceRecordType.dubiousScore
            }
            self.dismissViewControllerAnimated(false, completion: nil)
            galaxy.currentJourney!.currentEncounter!.resumeEncounter(1)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    


    
    // FOR TESTING PURPOSES ONLY
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        galaxy.currentJourney!.currentEncounter!.concludeEncounter()
    }
    
    // use this when it is a notification with an OK button that does NOTHING but end the encounter
    func launchGenericSimpleModal() {
        let title = galaxy.currentJourney!.currentEncounter!.alertTitle
        let message = galaxy.currentJourney!.currentEncounter!.alertText
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // dismiss encounter dialog
            self.dismissViewControllerAnimated(false, completion: nil)
            // how to resume?
            galaxy.currentJourney!.currentEncounter!.concludeEncounter()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pirateOrTraderDestroyedAlert(type: IFFStatusType) {
        var title = ""
        var message = ""
        if type == IFFStatusType.Pirate && (player.policeRecordInt > 2) {
            let bounty = galaxy.currentJourney!.currentEncounter!.opponent.ship.bounty
            player.credits += bounty
            title = "Opponent Destroyed"
            message = "You have destroyed your opponent, earning a bounty of \(bounty) credits."
        } else {
            let bounty = galaxy.currentJourney!.currentEncounter!.opponent.ship.bounty
            player.credits += bounty
            
            title = "Opponent Destroyed"
            message = "You have destroyed your opponent."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // dismiss encounter dialog
            //self.dismissViewControllerAnimated(false, completion: nil)
            var number = 0
            switch player.difficulty {
                case DifficultyType.beginner:
                    number = 0
                case DifficultyType.easy:
                    number = 0
                case DifficultyType.normal:
                    number = 50
                case DifficultyType.hard:
                    number = 66
                case DifficultyType.impossible:
                    number = 75
            }
            
            if rand(100) > number {
                // scoop
                print("scooping...")
                self.scoop()
            } else {
                print("no scoop. Concluding encounter.")
                galaxy.currentJourney!.currentEncounter!.concludeEncounter()
            }
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func scoop() {
        // figure out what floated by
        let random = rand(galaxy.currentJourney!.currentEncounter!.opponent.ship.cargo.count)
        let itemType = galaxy.currentJourney!.currentEncounter!.opponent.ship.cargo[random].item
        let item = TradeItem(item: itemType, quantity: 1, pricePaid: 0)
        
        // launch alert to pick it up
        let title = "Scoop"
        let message = "A canister from the destroyed ship, labeled \(item.name), drifts within range of your scoops."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Pick It Up", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // dismiss and resume, for now
            print("you picked it up")
            player.commanderShip.cargo.append(item)
            self.dismissViewControllerAnimated(false, completion: nil)
            galaxy.currentJourney!.currentEncounter!.concludeEncounter()
        }))
        alertController.addAction(UIAlertAction(title: "Let It Go", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // dismiss and resume, for now
            print("you let it go")
            self.dismissViewControllerAnimated(false, completion: nil)
            galaxy.currentJourney!.currentEncounter!.concludeEncounter()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func submit() {
        var contraband = false
        for item in player.commanderShip.cargo {
            if (item.item == TradeItemType.Firearms) || (item.item == TradeItemType.Narcotics) {
                contraband = true
            }
        }
        
        // if not, apologise
        if !contraband {
            let title = "Nothing Found"
            let message = "The police find nothing illegal in your cargo holds, and apologise for the inconvenience."
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                // dismiss and conclude encounter
                self.dismissViewControllerAnimated(false, completion: nil)
                galaxy.currentJourney!.currentEncounter!.concludeEncounter()
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // if so, ask if you really want to submit to an inspection
            let title = "You Have Illegal Goods"
            let message = "Are you sure you want to let the police search you? You are carrying illegal goods!"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yes, let them", style: UIAlertActionStyle.Destructive ,handler: {
                (alert: UIAlertAction!) -> Void in
                // arrest
                self.arrest()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                // dismiss alert
                
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func arrest() {
        print("ARREST!")
        // Figure out punishment
        // close journey
        // mete out punishment
        // display appropriate modal
        // conclude journey
        
    }
    
    func gameOverModal() {
        let title: String = "You Lose"
        let message: String = "You ship has been destroyed by your opponent."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("gameOver", sender: nil)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
