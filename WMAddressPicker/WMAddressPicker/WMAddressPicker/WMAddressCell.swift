//
//  YMAreaCell.swift
//  RefuelNow
//
//  Created by Winson Zhang on 2018/12/19.
//  Copyright © 2018 LY. All rights reserved.
//

import UIKit

class WMAddressCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    var isSelect: Bool = false {
        didSet { selectedImageView.image = isSelect ? UIImage(named:"address_selected") : UIImage() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

    
}
