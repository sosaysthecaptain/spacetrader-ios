//
//  Newspaper.swift
//  SpaceTrader
//
//  Created by Marc Auger on 12/3/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import Foundation

class Newspaper {
    var stories: [String] = []
    
    init() {
        
    }
    
    func generatePaper() {
        self.stories = []
        
        
        
        getCannedHeadline()
        
        if self.stories.count < 5 {
            let emptyStringsNecessary = 5 - self.stories.count
            for _ in 0..<emptyStringsNecessary {
                self.stories.append("")
            }
        }
    }
    
    // Special Events get to go first, crowding out other news
    
    // local system status information
    
    // character-specific news
    
    // useful news. Chance of it appearing is 50% + 10% per difficulty level less than impossible
    // shows special conditions of other systems in range
    
    // moon vendor and tribble collector always get shown
    // (where are these? This is presumably anywhere within range?)
    
    // canned headlines--how many?
    
    func getCannedHeadline() {
        let random = rand(4)
        var headline: String = ""
        switch galaxy.currentSystem!.politics {
        case PoliticsType.anarchy:
            switch random {
            case 0: headline = "Riots, Looting Mar Factional Negotiations."
            case 1: headline = "Communities Seek Consensus."
            case 2: headline = "Successful Bakunin Day Rally!"
            case 3: headline = "Major Faction Conflict Expected for the Weekend!"
            default: headline = ""
            }
        case PoliticsType.capitalist:
            switch random {
            case 0: headline = "Editorial: Taxes Too High!"
            case 1: headline = "Market Indices Read Record Levels!"
            case 2: headline = "Corporate Profits Up!"
            case 3: headline = "Restrictions on Corporate Freedom Abolished by Courts!"
            default: headline = ""
            }
        case PoliticsType.communist:
            switch random {
            case 0: headline = "Party Reports Productivity Increase."
            case 1: headline = "Counter-Revolutionary Bureaucrats Purged from Party!"
            case 2: headline = "Party: Bold New Future Predicted!"
            case 3: headline = "Politburo Approves New 5-Year Plan!"
            default: headline = ""
            }
        case PoliticsType.confederacy:
            switch random {
            case 0: headline = "States Dispute Natural Resource Rights!"
            case 1: headline = "States Denied Federal Funds over Local Laws!"
            case 2: headline = "Southern States Resist Federal Taxation for Capital Projects!"
            case 3: headline = "States Request Federal Intervention in Citrus Conflict!"
            default: headline = ""
            }
        case PoliticsType.corporate:
            switch random {
            case 0: headline = "Robot Shortages Predicted for Q4."
            case 1: headline = "Profitable Quarter Predicted."
            case 2: headline = "CEO: Corporate Rebranding Progressing."
            case 3: headline = "Advertising Budgets to Increase."
            default: headline = ""
            }
        case PoliticsType.cybernetic:
            switch random {
            case 0: headline = "Olympics: Software Beats Wetware in All Events!"
            case 1: headline = "New Network Protocols To Be Deployed."
            case 2: headline = "Storage Banks to be Upgraded!"
            case 3: headline = "System Backup Rescheduled."
            default: headline = ""
            }
        case PoliticsType.democracy:
            switch random {
            case 0: headline = "Local Elections on Schedule!"
            case 1: headline = "Polls: Voter Satisfaction High!"
            case 2: headline = "Campaign Spending Aids Economy!"
            case 3: headline = "Police, Politicians Vow Improvements."
            default: headline = ""
            }
        case PoliticsType.dictatorship:
            switch random {
            case 0: headline = "New Palace Planned; Taxes Increase."
            case 1: headline = "Future Presents More Opportunities for Sacrifice!"
            case 2: headline = "Insurrection Crushed: Rebels Executed!"
            case 3: headline = "Police Powers to Increase!"
            default: headline = ""
            }
        case PoliticsType.fascist:
            switch random {
            case 0: headline = "Drug Smugglers Sentenced to Death!"
            case 1: headline = "Aliens Required to Carry Visible Identification at All Times!"
            case 2: headline = "Foreign Sabotage Suspected."
            case 3: headline = "Stricter Immigration Laws Installed."
            default: headline = ""
            }
        case PoliticsType.feudal:
            switch random {
            case 0: headline = "Farmers Drafted to Defend Lord's Castle!"
            case 1: headline = "Report: Kingdoms Near Flashpoint!"
            case 2: headline = "Baron Ignores Ultimatum!"
            case 3: headline = "War of Succession Threatens!"
            default: headline = ""
            }
        case PoliticsType.military:
            switch random {
            case 0: headline = "Court-Martials Up 2% This Year."
            case 1: headline = "Editorial: Why Wait to Invade?"
            case 2: headline = "HQ: Invasion Plans Reviewed."
            case 3: headline = "Weapons Research Increases Kill-Ratio!"
            default: headline = ""
            }
        case PoliticsType.monarchy:
            switch random {
            case 0: headline = "King to Attend Celebrations."
            case 1: headline = "Queen's Birthday Celebration Ends in Riots!"
            case 2: headline = "King Commissions New Artworks."
            case 3: headline = "Prince Exiled for Palace Plot!"
            default: headline = ""
            }
        case PoliticsType.pacifist:
            switch random {
            case 0: headline = "Dialog Averts Eastern Conflict!"
            case 1: headline = "Universal Peace: Is it Possible?"
            case 2: headline = "Universal Peace: Is it Possible?"
            case 3: headline = "Polls: Happiness Quotient High!"
            default: headline = ""
            }
        case PoliticsType.satori:
            switch random {
            case 0: headline = "Millions at Peace."
            case 1: headline = "Sun Rises."
            case 2: headline = "Countless Hearts Awaken."
            case 3: headline = "Serenity Reigns."
            default: headline = ""
            }
        case PoliticsType.socialist:
            switch random {
            case 0: headline = "Government Promises Increased Welfare Benefits!"
            case 1: headline = "Council Votes to Raise Minimum Wage."
            case 2: headline = "Maternity Benefits Increased!"
            case 3: headline = "Military Spending Cut Referendum Goes To Vote on Wednesday."
            default: headline = ""
            }
        case PoliticsType.technocracy:
            switch random {
            case 0: headline = "New Processor Hits 10 Zettaherz!"
            case 1: headline = "Nanobot Output Exceeds Expectation."
            case 2: headline = "Last Human Judge Retires."
            case 3: headline = "Software Bug Causes Mass Confusion."
            default: headline = ""
            }
        case PoliticsType.theocracy:
            switch random {
            case 0: headline = "High Priest to Hold Special Services."
            case 1: headline = "Temple Restoration Fund at 81%."
            case 2: headline = "Sacred Texts on Public Display."
            case 3: headline = "Dozen Blasphemers Excommunicated!"
            default: headline = ""
            }
        }
        self.stories.append(headline)
    }
}

enum NewsItemID: String {
    case artifactDelivery = "Scientist Adds Alien Artifact to Museum Collection."
    case caughtLittering = "Police Trace Orbiting Space Litter to <playerName>."
    case dragonfly = "Experimental Craft Stolen! Critics Demand Security Review."
    case dragonflyBaratas = "Investigators Report Strange Craft."
    case dragonflyDestroyed = "Spectacular Display as Stolen Ship Destroyed in Fierce Space Battle."
    case dragonflyMelina = "Rumors Continue: Melina Orbitted by Odd Starcraft."
    case dragonflyRegulas = "Strange Ship Observed in Regulas Orbit."
    case dragonflyZalkon = "Unidentified Ship: A Threat to Zalkon?"
    case experimentFailed = "Huge Explosion Reported at Research Facility."
    case experimentPerformed = "Travelers Report Spacetime Damage, Warp Problems!"
    case experimentStopped = "Scientists Cancel High-profile Test! Committee to Investigate Design."
    case experimentArrival = "Travelers Claim Sighting of Ship Materializing in Orbit!"
    case gemulon = "Editorial: Who Will Warn Gemulon?"
    case gemulonInvaded = "Alien Invasion Devastates Planet!"
    case gemulonRescued = "Invasion Imminent! Plans in Place to Repel Hostile Invaders."
    case captAhabAttacked = "Thug Assaults Captain Ahab!"
    case captAhabDestroyed = "Destruction of Captain Ahab's Ship Causes Anger!"
    case captConradAttacked = "Captain Conrad Comes Under Attack By Criminal!"
    case captConradDestroyed = "Captain Conrad's Ship Destroyed by Villain!"
    case captHuieAttacked = "Famed Captain Huie Attacked by Brigand!"
    case captHuieDestroyed = "Citizens Mourn Destruction of Captain Huie's Ship!"
    case japori = "Editorial: We Must Help Japori!"
    case japoriDelivery = "Disease Antidotes Arrive! Health Officials Optimistic."
    case jarekGetsOut = "Ambassador Jarek Returns from Crisis."
    case scarab = "Security Scandal: Test Craft Confirmed Stolen."
    case scarabDestroyed = "Wormhole Traffic Delayed as Stolen Craft Destroyed."
    case scarabHarass = "Wormhole Travelers Harassed by Unusual Ship!"
    case spaceMonster = "Space Monster Threatens Homeworld!"
    case spaceMonsterKilled = "Hero Slays Space Monster! Parade, Honors Planned for Today."
    case wildArrested = "Notorious Criminal Jonathan Wild Arrested!"
    case wildGetsOut = "Rumors Suggest Known Criminal J. Wild May Come to Kravat!"
    case sculptureStolen = "Priceless collector's item stolen from home of Geurge Locas!"
    case sculptureTracked = "Space Corps follows **** with alleged stolen sculpture to ****."
    case princess = "Member of Royal Family kidnapped!"
    case princessCentauri = "Aggressive Ship Seen in Orbit Around Centauri"
    case princessInthara = "Dangerous Scorpion Damages Several Other Ships Near Inthara"
    case princessQuonos = "Kidnappers Holding Out at Qonos"
    case princessRescued = "Scorpion Defeated! Kidnapped Member of Galvon Royal Family Freed!"
    case princessReturned = "Beloved Royal Returns Home!"
    
}