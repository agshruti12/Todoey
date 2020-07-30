//
//  Item.swift
//  Todoey
//
//  Created by Sumit K Agarwal on 7/30/20.
//  Copyright © 2020 Shruti Agarwal. All rights reserved.
//

import Foundation

class Item {
    
    var title:String!
    var checked:Bool!
    
    init(title:String = "") {
        self.title = title
        checked = false
    }
    
    
}
