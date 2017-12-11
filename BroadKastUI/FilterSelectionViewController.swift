//
//  FilterSelectionViewController.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 10/31/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController , UINavigationControllerDelegate{
   
    var studyTag: Bool = false
    var sportTag: Bool = false
    var foodTag: Bool = false
    var partyTag: Bool = false
    var hangoutTag: Bool = false
    var selectedAFilter: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        studyTag = false
        sportTag = false
        foodTag = false
        partyTag = false
        hangoutTag = false
        selectedAFilter = false
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
            selectedAFilter = true
            mapvc.studyFilter = studyTag
        }
        else {
            mapvc.studyFilter = false
        }
        
        if sportTag == true {
            selectedAFilter = true
            mapvc.sportFilter = sportTag
        }
        else {
            mapvc.sportFilter = false
        }
        
        if foodTag == true {
            selectedAFilter = true
            mapvc.foodFilter = foodTag
        }
        else {
            mapvc.foodFilter = false
        }
        
        if partyTag == true {
            selectedAFilter = true
            mapvc.partyFilter = partyTag
        }
        else {
            mapvc.partyFilter = false
        }
        
        if hangoutTag == true {
            selectedAFilter = true
            mapvc.hangoutFilter = hangoutTag
        }
        else {
            mapvc.hangoutFilter = false
        }
        
        if selectedAFilter == true {
            mapvc.didSelectFilter = true
        } else {
            mapvc.didSelectFilter = false
        }
    }
}
