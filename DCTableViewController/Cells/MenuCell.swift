//
//  MenuCell.swift
//  DCTableViewController
//
//  Created by Dan on 13.10.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell, DCTableViewCellProtocol, ReusableView {

    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(viewModel: Any, delegate: Any?) {
        guard let unwrappedViewModel = viewModel as? String else { return }
        
        label.text = unwrappedViewModel
    }
}
