//
//  FilterSelectionViewController.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 10/31/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController {
    
    
    
    // TODO: This class/view will show selectable filter options for the map.
    var tag: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func studyButton(_ sender: UIButton) {
        tag = "Study"
        performSegue(withIdentifier: "filter2map", sender: self)
    }
    
    @IBAction func sportButton(_ sender: UIButton) {
        tag = "Sport"
        performSegue(withIdentifier: "filter2map", sender: self)
    }
    
    @IBAction func foodButton(_ sender: UIButton) {
        tag = "Food"
        performSegue(withIdentifier: "filter2map", sender: self)
    }
    
    @IBAction func partyButton(_ sender: UIButton) {
        tag = "Party"
    }
    
    @IBAction func hangoutButton(_ sender: UIButton) {
        tag = "Hang Out"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapController = segue.destination as! mapViewController
        mapController.filterSelection = tag
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
