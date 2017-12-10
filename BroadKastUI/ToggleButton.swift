//
//  ToggleButton.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 12/10/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {

    var toggle = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateToggle(bool: !toggle)
    }
    
    func activateToggle(bool: Bool) {
        toggle = bool
        
        // Dummie functionality for testing
        let title = bool ? "On" : "Off"
        setTitle(title, for: .normal)
        
        // Actual functionality. Needs to change color if it's true.
        /*
        let color = bool ? .blue : .clear
        backgroundColor = color
        */
        
    }
}
