//
//  FilterSelectionViewController.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 10/31/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

/* TODO 12/10/17:
 1. Filters should change colors when active
 */

import UIKit

class FilterSelectionViewController: UIViewController , UINavigationControllerDelegate{
   
    var studyTag: Bool = false
    var sportTag: Bool = false
    var foodTag: Bool = false
    var partyTag: Bool = false
    var hangoutTag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func studyButton(_ sender: ToggleButton) {
        studyTag = !studyTag
    }
    
    @IBAction func sportButton(_ sender: ToggleButton) {
        sportTag = !sportTag
    }
    
    @IBAction func foodButton(_ sender: ToggleButton) {
        foodTag = !foodTag
    }
    
    @IBAction func partyButton(_ sender: ToggleButton) {
        partyTag = !partyTag
    }
    
    @IBAction func hangoutButton(_ sender: ToggleButton) {
        hangoutTag = !hangoutTag
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "filter2map", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapvc = segue.destination as! mapViewController
        
        if studyTag == true {
            mapvc.studyFilter = studyTag
        }
        else {
            mapvc.studyFilter = false
        }
        
        if sportTag == true {
            mapvc.sportFilter = sportTag
        }
        else {
            mapvc.sportFilter = false
        }
        
        if foodTag == true {
            mapvc.foodFilter = foodTag
        }
        else {
            mapvc.foodFilter = false
        }
        
        if partyTag == true {
            mapvc.partyFilter = partyTag
        }
        else {
            mapvc.partyFilter = false
        }
        
        if hangoutTag == true {
            mapvc.hangoutFilter = hangoutTag
        }
        else {
            mapvc.hangoutFilter = false
        }
        
        mapvc.didSelectFilter = true
    }
}
