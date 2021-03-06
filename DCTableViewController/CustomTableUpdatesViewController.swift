//
//  CustomTableUpdatesViewController.swift
//  DCTableViewController
//
//  Created by Dan on 08.09.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

enum TestCells: String, CellTypeDescribing {
    case testCell
}

class CustomTableUpdatesViewController: DCTableViewController {
    
    var customIteration: Int = 1
    var updateTimer: Timer!
    var sectionIndex = 0
    
    var initialState: [(sectionID: Int, sectionCellIDs: [Int])] =
        [
            (sectionID: 0, sectionCellIDs: [0,1,5]),
            (sectionID: 2, sectionCellIDs: [0,1,2,3,4,5])
        ]
    
    var finalState: [(sectionID: Int, sectionCellIDs: [Int])]  =
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
            print("Registration error")
        }
        
        tableView.registerCellNib(TestCell.self)
        
        createDataSourceForTable(tableView)
        tableView.reloadData()
        
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomTableUpdatesViewController.refreshTable), userInfo: nil, repeats: true)
    }

    // MARK: - Table View

    func createDataSourceForTable(_ tableView: UITableView) {
        
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

    
    fileprivate func _dataSourceFromArray(_ array: [(sectionID: Int, sectionCellIDs: [Int])])
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
                    cellType: TestCells.testCell,
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
        animateTableChanges(tableView, withUpdates: true, insertAnimation: .fade, deleteAnimation: .fade)
    }
    
}

