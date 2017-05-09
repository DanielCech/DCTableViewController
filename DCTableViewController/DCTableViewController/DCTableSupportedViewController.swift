//
//  DCTableSupportedViewController.swift
//  DCTableViewController
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

class DCTableSupportedViewController: UIViewController, DCTableViewHandling {

//    typealias CellDescriptionType = CellDescription
//    typealias SectionDescriptionType = SectionDescription
    
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return protocolNumberOfSectionsInTableView(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return protocolTableView(tableView, numberOfRowsInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Cell
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, cellDescription: nil)
    }
    
    
    func tableView(
        _ tableView: UITableView,
        willUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
    {
        // Rewrite in descendants
    }
    
    func tableView(
        _ tableView: UITableView,
        didUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
    {
        // Rewrite in descendants
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAtIndexPath indexPath: IndexPath,
        cellDescription: CellDescription?) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true)
        
        if let unwrappedCellDescription = cellDescription {
            cell = tableView.dequeueReusableCell(withIdentifier: unwrappedCellDescription.cellType.cellName, for: indexPath)
            
            self.tableView(tableView, willUpdateCell: cell!, cellDescription: unwrappedCellDescription)
            
            if let cellProtocol = cell as? DCTableViewCellProtocol {
                if let unwrappedViewModel = unwrappedCellDescription.viewModel {
                    cellProtocol.updateCell(viewModel: unwrappedViewModel, delegate: unwrappedCellDescription.delegate)
                }
            }
            
            self.tableView(tableView, didUpdateCell: cell!, cellDescription: unwrappedCellDescription)
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return protocolTableView(tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return protocolTableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return protocolTableView(tableView, titleForHeaderInSection: section)
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//    {
//        return protocolTableView(tableView, estimatedHeightForHeaderInSection: section)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return protocolTableView(tableView, heightForHeaderInSection: section)
    }

    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return protocolTableView(tableView, titleForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return protocolTableView(tableView, heightForFooterInSection: section)
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        protocolTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath)
    {
        protocolTableView(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    
    
    

    
}
