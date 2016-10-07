//
//  RandomTableUpdatesViewController.swift
//  DCTableViewController
//
//  Created by Dan on 08.09.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class RandomTableUpdatesViewController: DCTableViewController {
    
    var customIteration: Int = 1
    var updateTimer: NSTimer!
    var sectionIndex = 0

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
        _addSection(0)
        _addSection(1)
        _addSection(2)
//        _addSection(3)
//        _addSection(4)
        print("DataSourceEnd")
    }

    
    private func _addSection(section: Int)
    {
        if arc4random() % 4 > 2 {
            return
        }
        
        let sectionDescription = SectionDescription(
            sectionID: section,
            headerTitle: "Section \(section)"
        )
        
        var cellDescriptions = [CellDescription]()
        var indexes: [Int] = []
        
        for index in 0...5 {
        
            if arc4random() % 4 > 2 {
                continue
            }
            
            indexes.append(index)
            
            let cellDescription = CellDescription(
                cellID: index,
                cellType: .TestCell,
                viewModel: "Cell \(index)"
            )
            
            cellDescriptions.append(cellDescription)
            
        }
        
        print("    Section \(sectionIndex) '\(section)': \(indexes)")
        
        self.tableView(tableView, addSection: sectionDescription, withCells: cellDescriptions)
        
        sectionIndex += 1
    }

    
    func refreshTable()
    {
        createDataSourceForTable(tableView)
        animateTableChanges(tableView, withUpdates: true, insertAnimation: .Fade, deleteAnimation: .Fade)
    }
    
}

