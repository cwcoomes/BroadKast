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
        let defaultTitle = toggle ? "On" : "Off"
        let defaultColor = toggle ? UIColor(hex: "00394b") : UIColor.white
        
        setTitle(defaultTitle, for: .normal)
        backgroundColor = defaultColor
    }
    
    @objc func buttonPressed() {
        activateToggle(bool: !toggle)
    }
    
    func activateToggle(bool: Bool) {
        toggle = bool
        
        let title = bool ? "On" : "Off"
        let color = bool ? UIColor(hex: "00394b") : UIColor.white
        
        setTitle(title, for: .normal)
        backgroundColor = color
        
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


