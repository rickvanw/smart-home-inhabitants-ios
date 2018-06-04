//
//  UIScrollView + resizeScrollViewContentSize.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 17/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}
