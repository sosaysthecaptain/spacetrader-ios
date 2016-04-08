//
//  MercenaryDetailVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 12/2/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import UIKit

class MercenaryDetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dailyCostLabel: UILabel!
    @IBOutlet weak var pilotLabel: UILabel!
    @IBOutlet weak var fighterLabel: UILabel!
    @IBOutlet weak var traderLabel: UILabel!
    @IBOutlet weak var engineerLabel: UILabel!
    @IBOutlet weak var hireButtonLabel: PurpleButtonTurnsGray!

    
    
    var selectedMercenary: CrewMember?
    var hireNotFire: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInformation()
    }
    
    func displayInformation() {
        nameLabel.text = selectedMercenary!.name
        dailyCostLabel.text = "\(selectedMercenary!.costPerDay) cr. daily"
        pilotLabel.text = "\(selectedMercenary!.pilot)"
        fighterLabel.text = "\(selectedMercenary!.fighter)"
        traderLabel.text = "\(selectedMercenary!.trader)"
        engineerLabel.text = "\(selectedMercenary!.engineer)"
        
        let controlState = UIControlState()
        if hireNotFire! {
            hireButtonLabel.setTitle("Hire", forState: controlState)
        } else {
            hireButtonLabel.setTitle("Fire", forState: controlState)
            // impossible to fire Wild, Jarek, Ziyal
            if selectedMercenary!.ID == MercenaryName.jarek || selectedMercenary!.ID == MercenaryName.wild || selectedMercenary!.ID == MercenaryName.ziyal {
                hireButtonLabel.enabled = false
            } else {
                hireButtonLabel.enabled = true
            }
        }
    }
    
    @IBAction func hireFireButton(sender: AnyObject) {
        if hireNotFire! {
            if player.commanderShip.crew.count >= player.commanderShip.crewQuarters {
                let title = "No Quarters Available"
                let message = "You do not have quarters available for \(selectedMercenary!.name)."
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
                    (alert: UIAlertAction!) -> Void in
                    // do nothing
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                hireMercenary()
            }
        } else {
            let title = "Fire Mercenary"
            let message = "Are you sure you want fire \(selectedMercenary!.name)?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive ,handler: {
                (alert: UIAlertAction!) -> Void in
                self.fireMercenary()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                // do nothing
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func hireMercenary() {
        player.commanderShip.crew.append(selectedMercenary!)
        
        // remove from current system
        var indexOfMercenary = 0
        var currentIndex = 0
        for mercenary in galaxy.currentSystem!.mercenaries {
            if mercenary.ID == selectedMercenary!.ID {
                indexOfMercenary = currentIndex
            }
            currentIndex += 1
        }
        galaxy.currentSystem!.mercenaries.removeAtIndex(indexOfMercenary)
        
        self.navigationController?.popViewControllerAnimated(true)
        //self.performSegueWithIdentifier("unwind", sender: self)
        //performSegueWithIdentifier("finishedMercenaryDetail", sender: nil)
        //dismissViewControllerAnimated(true, completion: nil)
        //navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func fireMercenary() {
        var indexOfMercenary = 0
        var currentIndex = 0
        for mercenary in player.commanderShip.crew {
            if mercenary.ID == selectedMercenary!.ID {
                indexOfMercenary = currentIndex
            }
            currentIndex += 1
        }
        player.commanderShip.crew.removeAtIndex(indexOfMercenary)
        
        self.navigationController?.popViewControllerAnimated(true)
        //self.performSegueWithIdentifier("unwind", sender: self)
        //performSegueWithIdentifier("finishedMercenaryDetail", sender: nil)
        //dismissViewControllerAnimated(true, completion: nil)
        //navigationController?.popToRootViewControllerAnimated(true)
    }

}
