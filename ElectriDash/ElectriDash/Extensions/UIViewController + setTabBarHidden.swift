//
//  UIViewController + setTabBarHidden.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 14/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = self.view.frame.size.height + frame.size.height * factor
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
}
