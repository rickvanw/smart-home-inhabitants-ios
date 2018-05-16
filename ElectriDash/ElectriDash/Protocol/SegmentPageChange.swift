//
//  SegmentPageChange.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 23/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

protocol SegmentPageChange {
    
    func pageChangedToIndex(index: Int)
    func reloadCurrent()
    
}
