//
//  EventDetailsViewController.swift
//  BroadKastUI
//
//  Created by ubicomp4 on 11/1/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
   
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var tag: UILabel!
    
    @IBOutlet weak var eventDescription: UITextView!
    
    
    var eventToView = EventData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitle.text = eventToView.title
        eventDescription.text = eventToView.description
        tag.text = eventToView.KastTag
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
