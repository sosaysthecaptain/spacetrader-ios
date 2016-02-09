//
//  SpecialVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 12/3/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import UIKit

class SpecialVC: UIViewController {

    @IBOutlet weak var specialEventTitle: UILabel!
    @IBOutlet weak var specialEventText: UITextView!
    @IBOutlet weak var dismissButtonOutlet: CustomButton!
    @IBOutlet weak var noButtonOutlet: CustomButton!
    
    override func viewDidLoad() {
        // DEBUG
        print("special screen invoked. Special event to load: \(galaxy.currentSystem!.specialEvent)")
        print("title: \(player.specialEvents.specialEventTitle)")
        
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        if player.specialEvents.special {
            // DEBUG
            print("SpecialVC reporting in. specialEventID: \(galaxy.currentSystem!.specialEvent)")
            print("title, from player.specialEvents: \(player.specialEvents.specialEventTitle)")
            
            specialEventTitle.text = player.specialEvents.specialEventTitle
            specialEventText.text = player.specialEvents.specialEventText
            
            // set button texts
            let controlState = UIControlState()
            dismissButtonOutlet.setTitle(player.specialEvents.yesDismissButtonText, forState: controlState)
            noButtonOutlet.setTitle(player.specialEvents.noButtonText, forState: controlState)
            
            dismissButtonOutlet.enabled = player.specialEvents.yesDismissButtonEnabled
            noButtonOutlet.enabled = player.specialEvents.noButtonEnabled
        }
    }

    @IBAction func dismissButton(sender: AnyObject) {
        // NEW WAY--entire functionality goes here, no further callback to SpecialEvent
        // TODO
        switch galaxy.currentSystem!.specialEvent! {
            // initial
            case SpecialEventID.alienArtifact:
                player.specialEvents.addQuestString("Deliver the alien artifact to Professor Berger at some hi-tech system.", ID: QuestID.artifact)
                player.commanderShip.artifactOnBoard = true
                // add artifact delivery to some high tech system without a specialEvent set
                for planet in galaxy.planets {
                    if planet.techLevel == TechLevelType.techLevel7 {
                        if planet.specialEvent == nil {
                            galaxy.setSpecial(planet.name, id: SpecialEventID.artifactDelivery)
                        }
                    }
                }
                player.specialEvents.artifactOnBoard = true
                
            case SpecialEventID.dragonfly:
                player.specialEvents.addQuestString("Follow the Dragonfly to Melina.", ID: QuestID.dragonfly)
                galaxy.setSpecial("Melina", id: SpecialEventID.dragonflyMelina)
                
            case SpecialEventID.dangerousExperiment:
                player.specialEvents.experimentCountdown = 10
                player.specialEvents.addQuestString("Stop Dr. Fehler's experiment at Daled within \(player.specialEvents.experimentCountdown) days.", ID: QuestID.experiment)
                galaxy.setSpecial("Daled", id: SpecialEventID.disasterAverted)
                
            case SpecialEventID.gemulonInvasion:
                player.specialEvents.gemulonInvasionCountdown = 7
                player.specialEvents.addQuestString("Inform Gemulon about alien invasion within \(player.specialEvents.gemulonInvasionCountdown) days.", ID: QuestID.gemulon)
                galaxy.setSpecial("Gemulon", id: SpecialEventID.gemulonRescued)
                
            case SpecialEventID.japoriDisease:
                // player can accept quest only if ship has 10 bays free
                if player.commanderShip.baysAvailable >= 10 {
                    // quest
                    player.specialEvents.addQuestString("Deliver antidote to Japori.", ID: QuestID.japori)
                    // create new special in Japori--medicineDelivery
                    galaxy.setSpecial("Japori", id: SpecialEventID.medicineDelivery)
                    player.commanderShip.japoriSpecialCargo = true
                } else {
                    // if bays not free, create alert, put back special
                    print("error. Not enough bays available. CREATE ALERT.")                // ADD ALERT
                    galaxy.setSpecial("Gemulon", id: SpecialEventID.fuelCompactor)
                    dontDeleteLocalSpecialEvent = true
                }
                
                
                
            case SpecialEventID.ambassadorJarek:
                
                
                player.specialEvents.jarekElapsedTime = 0
                player.specialEvents.addQuestString("Take ambassador Jarek to Devidia.", ID: QuestID.jarek)
                galaxy.setSpecial("Devidia", id: SpecialEventID.jarekGetsOut)
                
                if player.commanderShip.crewSlotsAvailable >= 1 {
                    // take him on
                    let jarek = CrewMember(ID: MercenaryName.jarek, pilot: 1, fighter: 1, trader: 10, engineer: 1)    // are these the numbers we want to use for Jarek? Maybe find out?
                    player.commanderShip.crew.append(jarek)
                } else {
                    // can't take him on
                    print("error. Not enough crew slots available. CREATE ALERT.")            // ADD ALERT
                    // restore special event at current system
                    galaxy.setSpecial(galaxy.currentSystem!.name, id: SpecialEventID.ambassadorJarek)
                    dontDeleteLocalSpecialEvent = true
                }
                
            case SpecialEventID.princess:
                player.specialEvents.addQuestString("Follow the Scorpion to Centauri.", ID: QuestID.princess)
                galaxy.setSpecial("Centauri", id: SpecialEventID.princessCentauri)
                
            case SpecialEventID.moonForSale:
                if player.credits >= 500000 {
                    // go for it
                    player.credits -= 500000
                    player.specialEvents.addQuestString("Claim your moon at Utopia.", ID: QuestID.moon)
                    galaxy.setSpecial("Utopia", id: SpecialEventID.retirement)
                } else {
                    // too poor message                                         ALERT
                    // put back special
                    galaxy.setSpecial(galaxy.currentSystem!.name, id: SpecialEventID.moonForSale)
                    dontDeleteLocalSpecialEvent = true
                }
                
                
                
            case SpecialEventID.morgansReactor:
                
                // add special cargo        FIX
                if player.commanderShip.baysAvailable >= 10 {
                    // quest
                    player.specialEvents.addQuestString("Deliver the unstable reactor to Nix for Henry Morgan.", ID: QuestID.reactor)
                    player.specialEvents.reactorElapsedTime = 0
                    galaxy.setSpecial("Nix", id: SpecialEventID.reactorDelivered)
                    player.commanderShip.reactorSpecialCargo = true
                    player.commanderShip.reactorFuelSpecialCargo = true
                    player.commanderShip.reactorFuelBays = 10

                    // ReactorOnBoard alert; close on dismiss
                    generateAlert(Alert(ID: AlertID.ReactorOnBoard, passedString1: nil, passedString2: nil, passedString3: nil))
                    
                } else {
                    // if bays not free, don't delete, create alert
                    dontDeleteLocalSpecialEvent = true
                    generateAlert(Alert(ID: AlertID.SpecialNotEnoughBays, passedString1: nil, passedString2: nil, passedString3: nil))
                }
                
            case SpecialEventID.scarabStolen:
                player.specialEvents.addQuestString("Find and destroy the Scarab (which is hiding at the exit to a wormhole).", ID: QuestID.scarab)
                // add scarab to some planet with a wormhole
                for planet in galaxy.planets {
                    if (planet.wormhole == true) && (planet.specialEvent == nil) {
                        planet.scarabIsHere = true
                        print("scarab is at \(planet.name)")
                        break
                    }
                }
                closeSpecialVC()
                // **** UPON DESTRUCTION OF SCARAB, UPDATE QUESTSTRING AND ADD SCARABDESTROYED SPECIAL TO CURRENT SYSTEM
                
                
            case SpecialEventID.sculpture:
                player.specialEvents.addQuestString("Deliver the stolen sculpture to Endor.", ID: QuestID.sculpture)
                galaxy.setSpecial("Endor", id: SpecialEventID.sculptureDelivered)
                player.commanderShip.sculptureSpecialCargo = true
                closeSpecialVC()
                
            case SpecialEventID.spaceMonster:
                player.specialEvents.addQuestString("Kill the space monster at Acamar.", ID: QuestID.spaceMonster)
                for planet in galaxy.planets {
                    if planet.name == "Acamar" {
                        planet.spaceMonsterIsHere = true
                    }
                }
                
            case SpecialEventID.wild:
                // **** MAKE SURE ENOUGH SPACE TO TAKE ON WILD
                player.specialEvents.wildOnBoard = true
                player.specialEvents.wildElapsedTime = 0
                player.specialEvents.addQuestString("Smuggle Jonathan Wild to Kravat", ID: QuestID.wild)
                galaxy.setSpecial("Kravat", id: SpecialEventID.wildGetsOut)
                // **** ADD WILD TO CREW, TAKE HIS SKILLS INTO ACCOUNT
                
            case SpecialEventID.merchantPrice:
                player.commanderShip.tribbles = 1       // NEED UPDATETRIBBLE FUNCTION
                player.specialEvents.addQuestString("Get rid of those pesky tribbles.", ID: QuestID.tribbles) // is it time for this yet?
                // add tribble buyer somewhere. **** IS IT TIME FOR THIS YET?
                for planet in galaxy.planets {
                    if planet.specialEvent == nil {
                        planet.specialEvent = SpecialEventID.tribbleBuyer
                    }
                }
                
            case SpecialEventID.eraseRecord:
                if player.credits >= 5000 {
                    player.policeRecord = PoliceRecordType.cleanScore
                    player.credits -= 5000
                } else {
                    // **** YOU CAN'T AFFORD THIS ALERT
                    // **** REINSTATE SPECIAL EVENT, SINCE WE HAVEN'T USED IT AND DON'T WANT IT GONE
                }
                
                
            case SpecialEventID.lotteryWinner:
                player.credits += 1000
                
            case SpecialEventID.skillIncrease:
                if player.credits >= 3000 {
                    player.credits -= 3000
                    player.specialEvents.increaseRandomSkill()
                } else {
                    // **** TOO POOR MESSAGE & REINSTATE SPECIAL
                }
                
            case SpecialEventID.cargoForSale:
                if player.credits >= 1000 {
                    if player.commanderShip.cargoBays >= 3 {
                        player.credits -= 1000
                        player.specialEvents.addRandomCargo()
                    } else {
                        // **** TOO FEW BAYS MESSAGE
                    }
                } else {
                    // **** TOO POOR MESSAGE
                }
                
                // subsequent
            case SpecialEventID.artifactDelivery:
                player.specialEvents.artifactOnBoard = false
                player.commanderShip.artifactOnBoard = false
                player.credits += 20000
                player.specialEvents.addQuestString("", ID: QuestID.artifact)        // close quest
                
            case SpecialEventID.dragonflyBaratas:
                player.specialEvents.addQuestString("Follow the Dragonfly to Melina.", ID: QuestID.dragonfly)
                galaxy.setSpecial("Melina", id: SpecialEventID.dragonflyMelina)
                
            case SpecialEventID.dragonflyMelina:
                player.specialEvents.addQuestString("Follow the Dragonfly to Regulas", ID: QuestID.dragonfly)
                galaxy.setSpecial("Regulas", id: SpecialEventID.dragonflyRegulas)
                
            case SpecialEventID.dragonflyRegulas:
                player.specialEvents.addQuestString("Follow the Dragonfly to Zalkon.", ID: QuestID.dragonfly)
                for planet in galaxy.planets {
                    if planet.name == "Zalkon" {
                        planet.dragonflyIsHere = true
                    }
                }
                // no new special. Will be added at Zalkon when dragonfly is destroyed
                
            case SpecialEventID.dragonflyDestroyed:
                player.specialEvents.addQuestString("Get your lightning shield at Zalkon.", ID: QuestID.dragonfly)
                galaxy.setSpecial("Zalkon", id: SpecialEventID.lightningShield)
                dontDeleteLocalSpecialEvent = true
                
            case SpecialEventID.lightningShield:
                if player.commanderShip.shield.count < player.commanderShip.shieldSlots {
                    // add shield
                    player.commanderShip.shield.append(Shield(type: ShieldType.lightningShield))
                    player.specialEvents.addQuestString("", ID: QuestID.dragonfly)
                } else {
                    // **** NOT ENOUGH SHIELD SLOTS MESSAGE
                    galaxy.setSpecial("Zalkon", id: SpecialEventID.lightningShield)
                    dontDeleteLocalSpecialEvent = true
                }
                
            case SpecialEventID.disasterAverted:
                player.specialEvents.experimentCountdown = -1        // deactivate countdown
                player.portableSingularity = true
                player.specialEvents.addQuestString("", ID: QuestID.experiment)
                
            case SpecialEventID.experimentFailed:
                player.specialEvents.addQuestString("", ID: QuestID.experiment)
                // spacetime was already messed up when the timer expired
                
            case SpecialEventID.gemulonInvaded:
                // aliens already appeared when timer expired
                player.specialEvents.addQuestString("", ID: QuestID.gemulon)
                
            case SpecialEventID.gemulonRescued:
                player.specialEvents.gemulonInvasionCountdown = -1   // deactivate countdown
                player.specialEvents.addQuestString("", ID: QuestID.gemulon)
                galaxy.setSpecial("Gemulon", id: SpecialEventID.fuelCompactor)
                dontDeleteLocalSpecialEvent = true
                
            case SpecialEventID.fuelCompactor:
                if player.commanderShip.gadget.count < player.commanderShip.gadgetSlots {
                    // add gadget
                    player.commanderShip.gadget.append(Gadget(type: GadgetType.FuelCompactor))
                    player.specialEvents.addQuestString("", ID: QuestID.dragonfly)
                } else {
                    // **** NOT ENOUGH GADGET SLOTS MESSAGE
                    galaxy.setSpecial("Gemulon", id: SpecialEventID.fuelCompactor)
                    dontDeleteLocalSpecialEvent = true
                }
                
            case SpecialEventID.medicineDelivery:
                player.commanderShip.japoriSpecialCargo = false     // remove special cargo
                player.specialEvents.addQuestString("", ID: QuestID.japori)
                player.specialEvents.increaseRandomSkill()                               // DO WE WANT AN ALERT HERE?
                
            case SpecialEventID.jarekGetsOut:
                // remove jarek
                player.commanderShip.removeCrewMember(MercenaryName.jarek)
                // stop countdown, remove quest string
                player.specialEvents.jarekElapsedTime = -1
                player.specialEvents.addQuestString("", ID: QuestID.jarek)
                // add special cargo, if possible
                if player.commanderShip.baysAvailable >= 1 {
                    player.initialTraderSkill += 2
                    player.commanderShip.jarekHagglingComputerSpecialCargo = true
                    print("haggling computer bool: \(player.commanderShip.jarekHagglingComputerSpecialCargo)")
                }
                // I guess otherwise you don't get the bump in trader skill?
                
                
                
            case SpecialEventID.princessCentauri:
                player.specialEvents.addQuestString("Follow the Scorpion to Inthara.", ID: QuestID.princess)
                galaxy.setSpecial("Inthara", id: SpecialEventID.princessInthara)
                
            case SpecialEventID.princessInthara:
                player.specialEvents.addQuestString("Follow the Scorpion to Qonos.", ID: QuestID.princess)
                for planet in galaxy.planets {
                    if planet.name == "Qonos" {
                        planet.scorpionIsHere = true
                    }
                }
                // upon defeat of the scorpion, SpecialEventID.princessQonos will be added
                
            case SpecialEventID.princessQonos:
                
                player.specialEvents.addQuestString("Transport Ziyal from Qonos to Galvon.", ID: QuestID.princess)
                galaxy.setSpecial("Galvon", id: SpecialEventID.princessReturned)
                
            case SpecialEventID.princessReturned:
                player.specialEvents.princessElapsedTime = -1
                player.specialEvents.addQuestString("Get your Quantum Disruptor at Galvon.", ID: QuestID.princess)
                galaxy.setSpecial("Galvon", id: SpecialEventID.installQuantumDisruptor)
                
            case SpecialEventID.installQuantumDisruptor:
                if player.commanderShip.weapon.count < player.commanderShip.weaponSlots {
                    // add disruptor
                    player.commanderShip.weapon.append(Weapon(type: WeaponType.quantumDisruptor))
                    player.specialEvents.addQuestString("", ID: QuestID.princess)
                } else {
                    // **** NOT ENOUGH WEAPON SLOTS MESSAGE                                 ALERT
                    galaxy.setSpecial("Galvon", id: SpecialEventID.installQuantumDisruptor)
                    dontDeleteLocalSpecialEvent = true
                    
                }
                
            case SpecialEventID.retirement:
                //print("pushed yes on retire screen")
                player.specialEvents.addQuestString("", ID: QuestID.moon)
                // end game
                player.endGameType = EndGameStatus.BoughtMoon
                gameOver()
                
            case SpecialEventID.reactorDelivered:
                player.specialEvents.reactorElapsedTime = -1
                player.specialEvents.addQuestString("Get your special laser at Nix.", ID: QuestID.reactor)
                // remove reactor
                player.commanderShip.reactorSpecialCargo = false
                player.commanderShip.reactorFuelSpecialCargo = false
                player.commanderShip.reactorFuelBays = 0
                
                galaxy.setSpecial("Nix", id: SpecialEventID.installMorgansLaser)
                print("special is now \(galaxy.currentSystem!.specialEvent!)")
                dontDeleteLocalSpecialEvent = true
                closeSpecialVC()
                
            case SpecialEventID.installMorgansLaser:
                if player.commanderShip.weapon.count < player.commanderShip.weaponSlots {
                    // add laser
                    player.commanderShip.weapon.append(Weapon(type: WeaponType.morgansLaser))
                    player.specialEvents.addQuestString("", ID: QuestID.reactor)
                    generateAlert(Alert(ID: AlertID.EquipmentMorgansLaser, passedString1: nil, passedString2: nil, passedString3: nil))
                } else {
                    generateAlert(Alert(ID: AlertID.EquipmentNotEnoughSlots, passedString1: nil, passedString2: nil, passedString3: nil))
                    galaxy.setSpecial("Nix", id: SpecialEventID.installMorgansLaser)
                    dontDeleteLocalSpecialEvent = true
                }
                
            case SpecialEventID.scarabDestroyed:
                player.specialEvents.addQuestString("Get your hull upgraded at \(galaxy.currentSystem!.name)", ID: QuestID.scarab)
                galaxy.setSpecial("\(galaxy.currentSystem!.name)", id: SpecialEventID.upgradeHull)
                
            case SpecialEventID.upgradeHull:
                // **** ANY MESSAGE HERE?
                player.commanderShip.hullStrength += 150    // hopefully this is the best way to do this?
                player.specialEvents.addQuestString("", ID: QuestID.scarab)
                
            case SpecialEventID.sculptureDelivered:
                player.commanderShip.sculptureSpecialCargo = false
                player.specialEvents.addQuestString("Have hidden compartments installed at Endor.", ID: QuestID.sculpture)
                galaxy.setSpecial("Endor", id: SpecialEventID.installHiddenCompartments)
                dontDeleteLocalSpecialEvent = true
                closeSpecialVC()
                
            case SpecialEventID.installHiddenCompartments:
                if player.commanderShip.gadget.count < player.commanderShip.gadgetSlots {
                    // add gadget
                    player.commanderShip.gadget.append(Gadget(type: GadgetType.HBays))
                    player.specialEvents.addQuestString("", ID: QuestID.dragonfly)
                    generateAlert(Alert(ID: AlertID.EquipmentHiddenCompartments, passedString1: nil, passedString2: nil, passedString3: nil))
                } else {
                    galaxy.setSpecial("Endor", id: SpecialEventID.sculpture)
                    dontDeleteLocalSpecialEvent = true
                    generateAlert(Alert(ID: AlertID.EquipmentNotEnoughSlots, passedString1: nil, passedString2: nil, passedString3: nil))
                }
                
            case SpecialEventID.monsterKilled:
                player.specialEvents.addQuestString("", ID: QuestID.spaceMonster)
                player.credits += 15000
                
            case SpecialEventID.wildGetsOut:
                player.specialEvents.addQuestString("", ID: QuestID.wild)
                let zeethibal = CrewMember(ID: MercenaryName.zeethibal, pilot: 9, fighter: 9, trader: 9, engineer: 9)
                zeethibal.costPerDay = 0
                galaxy.currentSystem!.mercenaries.append(zeethibal)
                
            case SpecialEventID.tribbleBuyer:
                player.specialEvents.addQuestString("", ID: QuestID.tribbles)
                player.commanderShip.tribbles = 0
                player.specialEvents.tribblesOnBoard = false
            
        }
        // END yesDismiss FUNCTIONALITY*************************************************************
        
        // OLD WAY--call relevant function in SpecialEvent
        //player.specialEvents.yesDismissButton()
        
        // dismiss and remove special. No button will not remove special, that can be done manually in SpecialEvent
    }
    
    func closeSpecialVC() {
        if player.endGameType == EndGameStatus.GameNotOver {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // spare special event if dontDeleteLocalSpecialEvent flag is true
        if !dontDeleteLocalSpecialEvent {
            print("flag not set, deleting special event")
            galaxy.currentSystem!.specialEvent = nil
            player.specialEvents.special = false
        } else {
            print("not deleting special event, as per flag")
            // spare special event. It has been reset to something else, like claim item
            
            // make sure button points to correct special
        }
        dontDeleteLocalSpecialEvent = false
    }

    @IBAction func noButton(sender: AnyObject) {
        // for now, I'm going to assume that this will be unnecessary. Maybe I can change the text on it, but I think it will just dismiss the window without taking away the special?
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gameOver() {
        print("this is the gameOver method in special")
        //performSegueWithIdentifier("gameOverFromSpecial", sender: nil)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("gameOverVC")
        self.presentViewController(vc, animated: false, completion: nil)
        
        // this goes to a blank, test VC
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("testGameOver")
//        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    func generateAlert(alert: Alert) {
        // this is the new version. It's functionality is completely contained within the VC
        
        let alertController = UIAlertController(title: alert.header, message: alert.text, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default ,handler: {
            (alert: UIAlertAction!) -> Void in
            // if yes pressed, return true
            self.closeSpecialVC()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
