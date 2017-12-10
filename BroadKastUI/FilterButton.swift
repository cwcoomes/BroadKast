//
//  FilterButton.swift
//  BroadKastUI
//
//  Created by Cody W. Coomes on 12/10/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
    
    var filtersActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        addTarget(self, action: #selector(FilterButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateFilterSelection(bool: !filtersActive)
    }
    
    func activateFilterSelection(bool: Bool) {
        filtersActive = bool
        
        let title = bool ? "Edit Active Filters" : "Edit Active Filters"
        
        setTitle(title, for: .normal)
        
    }
}

    

