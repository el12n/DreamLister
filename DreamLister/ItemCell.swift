//
//  ItemCell.swift
//  DreamLister
//
//  Created by Alvaro De La Cruz on 11/1/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureItemCell(item: Item){
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
    }
    
}
