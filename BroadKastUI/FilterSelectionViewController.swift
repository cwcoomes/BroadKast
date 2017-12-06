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
    var tags = ["Study","Sport","Food","Party",
                "Hang Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func studyButton(_ sender: UIButton) {
    }
    
    @IBAction func sportButton(_ sender: UIButton) {
    }
    
    @IBAction func foodButton(_ sender: UIButton) {
    }
    
    @IBAction func partyButton(_ sender: UIButton) {
    }
    
    @IBAction func hangoutButton(_ sender: UIButton) {
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
