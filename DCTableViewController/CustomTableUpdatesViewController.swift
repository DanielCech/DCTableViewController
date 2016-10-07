//
//  CustomTableUpdatesViewController.swift
//  DCTableViewController
//
//  Created by Dan on 08.09.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class CustomTableUpdatesViewController: DCTableViewController {
    
    var customIteration: Int = 1
    var updateTimer: NSTimer!
    var sectionIndex = 0
    
    var initialState =
        [
            (sectionID: 0, sectionCellIDs: [0,1,5]),
            (sectionID: 2, sectionCellIDs: [0,1,2,3,4,5])
        ]
    
    var finalState =
        [
            (sectionID: 0, sectionCellIDs: [0,1,2,3,4,5]),
            (sectionID: 1, sectionCellIDs: [0,1,2,5]),
            (sectionID: 2, sectionCellIDs: [0,1,2,4])
        ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try registerTableView(tableView)
        }
        catch {
            print("Error")
        }
        
        tableView.registerCellNib(TestCell)
        
        createDataSourceForTable(tableView)
        tableView.reloadData()
        
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RandomTableUpdatesViewController.refreshTable), userInfo: nil, repeats: true)
    }

    // MARK: - Table View

    func createDataSourceForTable(tableView: UITableView) {
        
        super.createDataSourceForTable(tableView)
        
        sectionIndex = 0
        
        print ("------------------------")
        print("DataSourceStart")
        
        switch customIteration {
        case 1:
            _dataSourceFromArray(initialState)
        case 2:
            _dataSourceFromArray(finalState)
        default:
            break
        }
        
        customIteration += 1
        
        print("DataSourceEnd")
    }

    
    private func _dataSourceFromArray(array: [(sectionID: Int, sectionCellIDs: [Int])])
    {
        for section in array {
            
            let sectionDescription = SectionDescription(
                sectionID: section.sectionID,
                headerTitle: "Section \(section.sectionID)"
            )
            
            var cellDescriptions = [CellDescription]()
            
            for cellID in section.sectionCellIDs {
                let cellDescription = CellDescription(
                    cellID: cellID,
                    cellType: .TestCell,
                    viewModel: "Cell \(cellID)"
                )
                
                cellDescriptions.append(cellDescription)
            }
            
            self.tableView(tableView, addSection: sectionDescription, withCells: cellDescriptions)
            
        }
    }

    
    func refreshTable()
    {
        if customIteration > 2 {
            updateTimer.invalidate()
            return
        }
        
        createDataSourceForTable(tableView)
        animateTableChanges(tableView, withUpdates: true, insertAnimation: .Fade, deleteAnimation: .Fade)
    }
    
}

