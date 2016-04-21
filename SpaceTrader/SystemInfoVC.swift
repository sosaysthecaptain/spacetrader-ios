//
//  SystemInfoVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 11/3/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import UIKit

class SystemInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        player.specialEvents.setSpecialEvent()              // experimental, to set second special
        updateUI()
        
        // arrival alerts
        if galaxy.journeyJustFinished {
            galaxy.journeyJustFinished = false
            fireNextArrivalAlert()
            
            if galaxy.meltdownOnArrival {
                // go to meltdown VC
                let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("meltdownVC")
                self.presentViewController(vc, animated: false, completion: nil)
            }
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var techLabel: UILabel!
    @IBOutlet weak var governmentLabel: UILabel!
    @IBOutlet weak var resourceLabel: UILabel!
    @IBOutlet weak var policeLabel: UILabel!
    @IBOutlet weak var piratesLabel: UILabel!
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var specialButton: UIButton!
    @IBOutlet weak var mercenariesButton: UIButton!
    @IBOutlet weak var fuelButton: UIButton!
    @IBOutlet weak var repairsButton: UIButton!
    
    @IBOutlet weak var fuelText1: UILabel!
    //@IBOutlet weak var fuelText2: UILabel!
    @IBOutlet weak var hullText1: UILabel!
    //@IBOutlet weak var hullText2: UILabel!

    //@IBOutlet weak var baysLabel: UILabel!
    //@IBOutlet weak var cashLabel: UILabel!
    //@IBOutlet weak var baysOutlet: BaysCashBox!
    //@IBOutlet weak var cashOutlet: BaysCashBox!
    @IBOutlet weak var baysCashView: BaysCashBoxView!
    
    
    
    func updateUI() {
        let localPolitics = Politics(type: galaxy.currentSystem!.politics)
        
        nameLabel.text = galaxy.currentSystem!.name
        sizeLabel.text = galaxy.currentSystem!.size.rawValue
        techLabel.text = galaxy.currentSystem!.techLevel.rawValue
        governmentLabel.text = galaxy.currentSystem!.politics.rawValue
        resourceLabel.text = galaxy.currentSystem!.specialResources.rawValue
        policeLabel.text = galaxy.getActivityForInt(localPolitics.activityPolice)
        piratesLabel.text = galaxy.getActivityForInt(localPolitics.activityPirates)
        
        baysCashView.redrawSelf()
        
        
        
//        fuelButton.backgroundColor = UIColor.clearColor()
//        fuelButton.layer.cornerRadius = 5
//        fuelButton.layer.borderWidth = 1
//        fuelButton.layer.borderColor = UIColor.blackColor().CGColor
//        fuelButton.titleEdgeInsets.left = 35
//        fuelButton.titleEdgeInsets.right = 35
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        //fuelButton.frame = CGRectMake(100, 100, 200, 40)
        //fuelButton.setTitle("Get Started", forState: UIControlState.Normal)
//        fuelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        fuelButton.backgroundColor = UIColor.clearColor()
//        fuelButton.layer.borderWidth = 1.0
//        fuelButton.layer.borderColor = UIColor.blackColor().CGColor         //UIColor(white: 0.0, alpha: borderAlpha).CGColor
//        fuelButton.layer.cornerRadius = cornerRadius
        
        
        let fuelNeeded = player.commanderShip.fuelTanks - player.commanderShip.fuel
        let fullTankCost = fuelNeeded * player.commanderShip.costOfFuel
        //fuelText1.text = "You have enough fuel to fly \(player.commanderShip.fuel) parsecs."
        if fuelNeeded == 0 {
            fuelText1.text = "You have enough fuel to fly \(player.commanderShip.fuel) parsecs. Your tank is full."
            // disappear fuel button
        } else {
            fuelText1.text = "You have enough fuel to fly \(player.commanderShip.fuel) parsecs. A full tank costs \(fullTankCost) cr."
            // make fuel button visible
        }

        
        let repairsNeeded = player.commanderShip.hullStrength - player.commanderShip.hull
        let repairsCost = repairsNeeded * player.commanderShip.repairCosts
        //hullText1.text = "Your hull strength is at \(player.commanderShip.hullPercentage)%."
        if repairsNeeded == 0 {
            hullText1.text = "Your hull strength is at \(player.commanderShip.hullPercentage)%. No repairs are needed."
            // disappear repairs button
        } else {
            hullText1.text = "Your hull strength is at \(player.commanderShip.hullPercentage)%. Full repairs will cost \(repairsCost) cr."
            // make repairs button visible
        }
        
        // make buttons appear as needed
        if galaxy.currentSystem!.mercenaries.count > 0 {
            mercenariesButton.enabled = true
        } else {
            mercenariesButton.enabled = false
        }
        
        if player.specialEvents.special {
            specialButton.enabled = true
        } else {
            specialButton.enabled = false
        }
        
        // disable fuel button if none needed
        if player.commanderShip.fuel == player.commanderShip.fuelTanks {
            fuelButton.enabled = false
        } else {
            fuelButton.enabled = true
        }
        
        // disable repair button if no repairs needed
        if player.commanderShip.hullPercentage == 100 {
            repairsButton.enabled = false
        } else {
            repairsButton.enabled = true
        }
        
        // shrink news/special/mercenary button text if small screen
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if screenSize.width < 350 {
            newsButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
            specialButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
            mercenariesButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        }
    }
    
    @IBAction func maxFuel(sender: AnyObject) {
        // figure out how much it will cost
        let fuelNeeded = player.commanderShip.fuelTanks - player.commanderShip.fuel
        let costOfFuel = fuelNeeded * player.commanderShip.costOfFuel
        
        // buy if possible
        if player.credits >= costOfFuel {
            player.credits -= costOfFuel
            player.commanderShip.fuel = player.commanderShip.fuelTanks
        }
        
        // update systemsInRange
        galaxy.getSystemsInRange()
        
        // update UI
        updateUI()
    }
    
    @IBAction func maxRepairs(sender: AnyObject) {
        let repairsNeeded = player.commanderShip.hullStrength - player.commanderShip.hull
        let costOfRepairs = repairsNeeded * player.commanderShip.repairCosts
        
        if player.credits >= costOfRepairs {
            player.credits -= costOfRepairs
            player.commanderShip.hull = player.commanderShip.hullStrength
        }
        updateUI()
        
    }
    
    @IBAction func buyNewspaper(sender: AnyObject) {
        if !player.alreadyPaidForNewspaper {
            var priceOfNewspaper: Int {
                get {
                    return (player.difficultyInt + 1)
                }
            }
            
            let title = "Buy Newspaper?"
            let message = "The local newspaper costs \(priceOfNewspaper) credits. Do you wish to buy a copy?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Buy Newspaper", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                if player.credits > priceOfNewspaper {
                    player.credits -= priceOfNewspaper
                }
                galaxy.currentSystem!.newspaper.generatePaper()     // actually generate the day's paper
                player.alreadyPaidForNewspaper = true
                self.performSegueWithIdentifier("newspaperModal", sender: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel ,handler: {
                (alert: UIAlertAction!) -> Void in
                // do nothing
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("newspaperModal", sender: nil)
        }
    }
    
    @IBAction func menuTapped(sender: AnyObject) {
        // PROVISIONAL
        print("OPEN QUESTS:")
        for quest in player.specialEvents.quests {
            if quest.completed == false {
                print(quest.questString)
            }
        }
    }
    
    func fireNextArrivalAlert() {
        if galaxy.alertsToFireOnArrival.count >= 1 {
            generateAlert(Alert(ID: galaxy.alertsToFireOnArrival[0], passedString1: nil, passedString2: nil, passedString3: nil))
            galaxy.alertsToFireOnArrival.removeAtIndex(0)
        }
    }
    
    func generateAlert(alert: Alert) {
        // NOTE: the alerts fired here need to be modified to require no passed strings, getting whatever they need directly
        
        let alertController = UIAlertController(title: alert.header, message: alert.text, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // when OK pressed, call fireNextArrivalAlert. Will end when no more.
            self.fireNextArrivalAlert()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        // if alert is reactor meltdown destroy ship!
        if alert.ID == AlertID.ReactorMeltdown {
            print("SHIP IS DESTROYED")
            if player.escapePod {
                // escape pod activated
                
            } else {
                // game over
                player.endGameType = EndGameStatus.Killed
                // transition to gameOver VC
            }
        }
    }
}
