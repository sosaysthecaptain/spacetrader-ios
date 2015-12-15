//
//  MenuVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 12/7/15.
//  Copyright © 2015 Marc Auger. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let section0 = ["New Game", "Load Game", "Save", "Save As"]
    let section1 = ["Commander Status", "Ship", "Personnel", "Quests", "Bank"]
    let section2 = ["High Scores"]
    let section3 = ["Options"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")


    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if indexPath.section == 0 {
            cell.textLabel?.text = section0[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = section1[indexPath.row]
        } else if indexPath.section == 2 {
            cell.textLabel?.text = section2[indexPath.row]
        } else {
            cell.textLabel?.text = section3[indexPath.row]
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return section0.count
        } else if section == 1 {
            return section1.count
        } else if section == 2 {
            return section2.count
        } else {
            return section3.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            print("selected: section 0, \(indexPath.row)")
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("commanderStatusSegue", sender: nil)
            case 1:
                performSegueWithIdentifier("shipSegue", sender: nil)
            case 2:
                performSegueWithIdentifier("personnelSegue", sender: nil)
            case 3:
                performSegueWithIdentifier("questsSegue", sender: nil)
            case 4:
                performSegueWithIdentifier("bankSegue", sender: nil)
            default: print("error")
            }
        } else if indexPath.section == 2 {
            print("selected: section 2, \(indexPath.row)")
        } else if indexPath.section == 3 {
            print("selected: section 3, \(indexPath.row)")
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}