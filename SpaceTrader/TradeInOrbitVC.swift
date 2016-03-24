//
//  TradeInOrbitVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 3/23/16.
//  Copyright © 2016 Marc Auger. All rights reserved.
//

import UIKit

protocol TradeInOrbitDelegate: class {
    func tradeDidFinish(controller: TradeInOrbitVC)
}

class TradeInOrbitVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: StandardLabel!
    @IBOutlet weak var secondLabel: StandardLabel!
    @IBOutlet weak var thirdLabel: StandardLabel!
    @IBOutlet weak var fourthLabel: StandardLabel!
    @IBOutlet weak var quantityLabel: PurpleHeader!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var cancelButton: GrayButtonTurnsLighter!
    @IBOutlet weak var tradeButton: PurpleButtonTurnsGray!
    
    weak var delegate: TradeInOrbitDelegate?
    
    // these things initialized to arbitrary values
    var encounterTypeIsBuy = false
    var commodityToTrade = TradeItemType.Water
    var tradeOfferAmount = 0
    var askPrice = 0
    var max = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    func loadData() {
        // determine if buying or selling
        if galaxy.currentJourney!.currentEncounter!.type == EncounterType.traderBuy {
            encounterTypeIsBuy = true
        } else {
            encounterTypeIsBuy = false
        }
        
        // determine what commodity
        if encounterTypeIsBuy {
            // choose whatever player has the most of
            commodityToTrade = player.commanderShip.getItemWithLargestQuantity
            
            // figure out how much of it trader is offering to buy
            tradeOfferAmount = Int(Double(galaxy.currentJourney!.currentEncounter!.opponent.ship.cargoBays) * 0.75)
            
            // generate ask price
            let localBuyPrice = galaxy.currentSystem!.getBuyPrice(commodityToTrade)
            askPrice = localBuyPrice + (rand(Int(Double(localBuyPrice) * 0.3))) - (rand(Int(Double(localBuyPrice) * 0.3)))
            print("local buy price is \(localBuyPrice), asking \(askPrice)")            // DEBUG
            
            // calculate max
//            let maxAfford = player.credits / askPrice
//            let maxRoom = player.commanderShip.baysAvailable
//            max = min(maxAfford, maxRoom, tradeOfferAmount)
            let maxRoom = galaxy.currentJourney!.currentEncounter!.opponent.ship.cargoBays - 3
            max = min(player.commanderShip.getQuantity(commodityToTrade), maxRoom)
            
            // set labels
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            let askPriceFormatted = numberFormatter.stringFromNumber(askPrice)
            
            titleLabel.text = "Sell \(commodityToTrade.rawValue)"
            firstLabel.text = "The trader wants to buy \(commodityToTrade.rawValue) at \(askPriceFormatted!) cr. each."
            secondLabel.text = "You have \(player.commanderShip.getQuantity(commodityToTrade)) units in your hold."
            thirdLabel.text = "The trader offers to buy \(max) units."
            fourthLabel.text = "How many do you want to sell?"
        } else {
            // SELL
            
        }
        
        // update slider stuff
        slider.minimumValue = 0
        slider.maximumValue = Float(max)
        slider.value = 0
        updateQuantityLabel()
    }
    
    func updateQuantityLabel() {
        quantityLabel.text = "\(Int(slider.value)) Units"
    }

    @IBAction func sliderDidMove(sender: AnyObject) {
        updateQuantityLabel()
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {
            //galaxy.currentJourney!.currentEncounter!.concludeEncounter()
            self.delegate?.tradeDidFinish(self)
        })
    }
    
    @IBAction func tradeTapped(sender: AnyObject) {
        // perform trade
        if encounterTypeIsBuy{
            player.commanderShip.removeCargo(commodityToTrade, quantity: Int(slider.value))
            player.credits += (askPrice * Int(slider.value))
            
            // launch alert
            let title: String = "Trade Completed"
            let message: String = "Thanks for selling the \(commodityToTrade.rawValue). It's been a pleasure doing business with you."
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                // end encounter, close VC
                //galaxy.currentJourney!.currentEncounter!.concludeEncounter()
                self.dismissViewControllerAnimated(false, completion: {
                        //galaxy.currentJourney!.currentEncounter!.concludeEncounter()
                    // fire delegate method here
                    self.delegate?.tradeDidFinish(self)
                })
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
}