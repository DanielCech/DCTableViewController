//
//  MenuViewController.swift
//  DCTableViewController
//
//  Created by Dan on 13.10.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class MenuViewController: DCTableSupportedViewController {

    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try registerTableView(tableView)
        }
        catch {
            print("Registration error")
        }
        
        tableView.registerCellNib(MenuCell.self)
        
        createDataSourceForTable(tableView)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table View
    
    func createDataSourceForTable(_ tableView: UITableView) {
        
        super.createDataSourceForTable(tableView)
        
        let sectionDescription = SectionDescription(
            sectionID: 0,
            footerHeight: { _ in 0.01 }
        )
        
        let cellDescriptions = [
            CellDescription(
                cellID: 0,
                cellType: .menuCell,
                viewModel: "Random Table Updates",
                didSelectCell: { [weak self] _, _, indexPath in
                    self?.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                    self?.performSegue(withIdentifier: "ShowRandomUpdates", sender: self)
                }
            ),
            CellDescription(
                cellID: 1,
                cellType: .menuCell,
                viewModel: "Custom Table Updates",
                didSelectCell: { [weak self] _, _, indexPath in
                    self?.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                    self?.performSegue(withIdentifier: "ShowCustomUpdates", sender: self)
                }
            ),
            CellDescription(
                cellID: 2,
                cellType: .menuCell,
                viewModel: "Infinite Loading List",
                didSelectCell: { [weak self] _, _, indexPath in
                    self?.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                    self?.performSegue(withIdentifier: "ShowInfiniteList", sender: self)
                }
            )
        ]
        
        self.tableView(tableView, addSection: sectionDescription, withCells: cellDescriptions)
    }

}
