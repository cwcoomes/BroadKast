//
//  PrivacyButton.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 12/9/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class PrivacyButton: UIButton {

    var isPrivate = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        addTarget(self, action: #selector(PrivacyButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activatePrivacyFilter(bool: !isPrivate)
    }
    
    func activatePrivacyFilter(bool: Bool) {
        isPrivate = bool
        
        let title = bool ? "Hide Private Events" : "Show Private Events"
        
        setTitle(title, for: .normal)
        
    }
    
    

}
