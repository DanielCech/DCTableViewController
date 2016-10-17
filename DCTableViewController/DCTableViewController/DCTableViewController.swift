//
//  DCTableViewController.swift
//  DCTableViewController
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

class DCTableViewController: UITableViewController, DCTableViewHandling {
    
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] = [:]
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return protocolNumberOfSectionsInTableView(tableView)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return protocolTableView(tableView, numberOfRowsInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Custom cell setup steps

    func tableView(
        tableView: UITableView,
        willUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
    {
        // Rewrite in descendants
    }
    
    func tableView(
        tableView: UITableView,
        didUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
    {
        // Rewrite in descendants
    }
 
    ////////////////////////////////////////////////////////////////
    // Cell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, cellDescription: nil)
    }
    
    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath,
        cellDescription: CellDescription?) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true)
        
        if let unwrappedCellDescription = cellDescription {
            cell = tableView.dequeueReusableCellWithIdentifier(unwrappedCellDescription.cellType.rawValue, forIndexPath: indexPath)
            
            self.tableView(tableView, willUpdateCell: cell!, cellDescription: unwrappedCellDescription)
            
            if let cellProtocol = cell as? DCTableViewCellProtocol {
                if let unwrappedViewModel = unwrappedCellDescription.viewModel {
                    cellProtocol.updateCell(viewModel: unwrappedViewModel, delegate: unwrappedCellDescription.delegate)
                }
            }
            
            self.tableView(tableView, willUpdateCell: cell!, cellDescription: unwrappedCellDescription)
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return protocolTableView(tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return protocolTableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return protocolTableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return protocolTableView(tableView, heightForHeaderInSection: section)
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return protocolTableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return protocolTableView(tableView, heightForFooterInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        protocolTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        protocolTableView(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    
    
}
