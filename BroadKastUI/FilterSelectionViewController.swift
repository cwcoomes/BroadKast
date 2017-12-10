//
//  FilterSelectionViewController.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 10/31/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

/* Cody's TODO 12/10/17:
 1. Apply button should pop the view from navbar stack
 2. Filters should change colors when active
 3. Each filter should have a variable
 4. Apply button should send those variables back to the map to apply filters
 */

import UIKit


extension FilterSelectionViewController{
    //data is passed to MapViewControllerfrom here
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? mapViewController)?.filters = filters
    }
}

class FilterSelectionViewController: UIViewController , UINavigationControllerDelegate{
    var filters = filterInfo()
    
    
    // TODO: This class/view will show selectable filter options for the map.
    var tag: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        print(filters)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func studyButton(_ sender: ToggleButton) {
        if(filters.studyFilter == false)
        {
            filters.studyFilter = true
            
        }
        else{
            filters.studyFilter = false
        }
        
    }
    
    @IBAction func sportButton(_ sender: ToggleButton) {
        if(filters.sportFilter == false)
        {
            filters.sportFilter = true
            
        }
        else{
            filters.sportFilter = false
        }
        print("button pressed")
    }
    
    @IBAction func foodButton(_ sender: ToggleButton) {
        if(filters.foodFilter == false)
        {
            filters.foodFilter = true
            
        }
        else{
            filters.foodFilter = false
        }
    }
    
    @IBAction func partyButton(_ sender: ToggleButton) {
        if(filters.partyFilter == false)
        {
            filters.partyFilter = true
            
        }
        else{
            filters.partyFilter = false
        }
    }
    
    @IBAction func hangoutButton(_ sender: ToggleButton) {
        if(filters.hangOutFilter == false)
        {
            filters.hangOutFilter = true
            
        }
        else{
            filters.hangOutFilter = false
        }
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "filter2map", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let mapController = segue.destination as! mapViewController
//        mapController.filterSelection = tag
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
