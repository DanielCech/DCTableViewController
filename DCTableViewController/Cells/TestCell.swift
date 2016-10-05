//
//  TestCell.swift
//  DCTableViewController
//
//  Created by Dan on 05.10.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell, DCTableViewCellProtocol, ReusableView {

    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(viewModel viewModel: Any, delegate: Any?) {
        guard let unwrappedViewModel = viewModel as? String else { return }
        
        contentLabel.text = unwrappedViewModel
    }
    
}
