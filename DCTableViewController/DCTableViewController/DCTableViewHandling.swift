//
//  DCTableViewHandling.swift
//  DCTableViewController
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


var enableDCTableViewControllerLoging = false

enum DCTableViewError: Error {
    case tagIsNotUnique
    case structureNotFound
    case sectionIndexOutOfBounds
    case rowIndexOutOfBounds
}

protocol DCTableViewHandling: class {

//    associatedtype CellDescription: CellDescribing
//    associatedtype SectionDescription: SectionDescribing
    
    /// Dictionary of table structures. Useful when controller contains more than one table view. TableView.tag is used as a key.
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] { get set }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Table setup
    
    func registerTableView(_ tableView: UITableView) throws
    
    func createDataSourceForTable(_ tableView: UITableView)
    
    func structureForTable(_ table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>?
    
    func tableView(
        _ tableView: UITableView,
        addSection section: SectionDescription,
        withCells cells: [CellDescription])
    
    func clearPreviousTableState(_ tableView: UITableView)
    

    ////////////////////////////////////////////////////////////////
    // MARK: - TableView data source methods
    
    func protocolNumberOfSectionsInTableView(_ tableView: UITableView, currentState: Bool) -> Int
    func protocolTableView(_ tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool) -> Int
    
    ////////////////////////////////////////////////////////////////
    // Cell
    
    func protocolTableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    func protocolTableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(_ tableView: UITableView, titleForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?

    func protocolTableView(_ tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(_ tableView: UITableView, titleForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?
    
    func protocolTableView(_ tableView: UITableView, heightForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription?)
    
    func protocolTableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription?)

    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID

    func tableView(
        _ tableView: UITableView,
        descriptionForCellWithID cellID: Int,
        inSectionWithID sectionID: Int,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSectionWithID section: Int,
        currentState: Bool) -> SectionDescription?
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: Int,
        currentState: Bool) -> String?
    
    func tableView(
        _ tableView: UITableView,
        sectionIDForSectionIndex section: Int,
        currentState: Bool) -> Int?
    
    func tableView(
        _ tableView: UITableView,
        indexOfSectionWithID sectionID: Int,
        currentState: Bool) -> Int?
    
    func tableView(_ tableView: UITableView, reloadSectionWithID sectionID: Int, rowAnimation: UITableViewRowAnimation)
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSection section: Int,
        currentState: Bool) -> SectionDescription?
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Animated table changes
    
    func animateTableChanges(
        _ tableView: UITableView,
        withUpdates: Bool,
        inSections: [Int]?,
        insertAnimation: UITableViewRowAnimation,
        deleteAnimation: UITableViewRowAnimation)

}
    
    

extension DCTableViewHandling {
    
    ////////////////////////////////////////////////////////////////
    // Table setup
    
    func registerTableView(_ tableView: UITableView) throws
    {
        if tableStructures[tableView.tag] != nil {
            throw DCTableViewError.tagIsNotUnique
        }
        
        let structure = DCTableViewStructure<CellDescription, SectionDescription>() //DCTableViewStructure<CellDescription, SectionDescription>()
        
        tableStructures[tableView.tag] = structure
    }

    
    func createDataSourceForTable(_ tableView: UITableView)
    {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        
        structure!.previousDataSourceCells = structure!.dataSourceCells
        structure!.previousDataSourceSections = structure!.dataSourceSections
        
        structure!.dataSourceCells = []
        structure!.dataSourceSections = []
        
        tableStructures[tableView.tag] = structure!
    }
    
    
    func structureForTable(_ table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>?
    {
        let structure = tableStructures[table.tag]
        
        if structure == nil {
            return nil
        }
        
        return structure!
    }
    
    
    func tableView(
        _ tableView: UITableView,
        addSection section: SectionDescription,
        withCells cells: [CellDescription])
    {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        structure!.dataSourceSections.append(section)
        structure!.dataSourceCells.append(cells)
        
        tableStructures[tableView.tag] = structure!
    }
    
    
    func clearPreviousTableState(_ tableView: UITableView)
    {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        structure!.previousDataSourceCells = []
        structure!.previousDataSourceSections = []
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - TableView data source methods
    
    func protocolNumberOfSectionsInTableView(_ tableView: UITableView, currentState: Bool = true) -> Int
    {
        let structure = structureForTable(tableView)
        if structure == nil {
            return 0
        }

        return structure!.getDataSourceSections(currentState).count
    }
    
    
    func protocolTableView(_ tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool = true) -> Int
    {
        let structure = structureForTable(tableView)
        if structure == nil {
            return 0
        }
        
        let dataSourceCells = structure!.getDataSourceCells(currentState)
        
        if section < dataSourceCells.count {
            return dataSourceCells[section].count
        }

        return 0
    }
    
    ////////////////////////////////////////////////////////////////
    // Cell
    

    func protocolTableView(
        _ tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: IndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat
    {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedEstimatedCellHeight = cellDescription.estimatedCellHeight {
                return unwrappedEstimatedCellHeight(cellDescription, indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func protocolTableView(
        _ tableView: UITableView,
        heightForRowAtIndexPath indexPath: IndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat
    {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedCellHeight = cellDescription.estimatedCellHeight {
                return unwrappedCellHeight(cellDescription, indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int,
        currentState: Bool = true, sectionDescription: SectionDescription? = nil) -> String?
    {
        let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState)
        return sectionDescription?.headerTitle
    }
    
    
//    func protocolTableView(
//        tableView: UITableView,
//        estimatedHeightForHeaderInSection section: Int,
//        currentState: Bool = true,
//        sectionDescription: SectionDescription? = nil) -> CGFloat
//    {
//        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
//            if let unwrappedEstimatedHeaderHeight = sectionDescription.estimatedHeaderHeight {
//                return unwrappedEstimatedHeaderHeight(sectionDescription: sectionDescription, section: section)
//            }
//            
//            //When estimatedHeightForHeaderInSection is available, heightForHeaderInSection is not called
//            return protocolTableView(tableView, heightForHeaderInSection: section, currentState: currentState, sectionDescription: sectionDescription)
//        }
//        
//        return UITableViewAutomaticDimension
//    }
    
    func protocolTableView(_ tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool = true, sectionDescription: SectionDescription? = nil) -> CGFloat
    {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedHeaderHeight = sectionDescription.headerHeight {
                return unwrappedHeaderHeight(sectionDescription, section)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> String?
    {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
        return sectionDescription.footerTitle
    }
    
    
    func protocolTableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> CGFloat
    {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedFooterHeight = sectionDescription.footerHeight {
                return unwrappedFooterHeight(sectionDescription, section)
            }
        }
        
        return 0
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription? = nil)
    {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didSelectCell = unwrappedCellDescription.didSelectCell {
            if let unwrappedCell = tableView.cellForRow(at: indexPath) {
                didSelectCell(unwrappedCell, unwrappedCellDescription, indexPath)
            }
        }
    }
    
    
    func protocolTableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription? = nil)
    {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didDeselectCell = unwrappedCellDescription.didDeselectCell {
            if let unwrappedCell = tableView.cellForRow(at: indexPath) {
                didDeselectCell(unwrappedCell, unwrappedCellDescription, indexPath)
            }
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID
    
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellWithID cellID: Int,
        inSectionWithID sectionID: Int,
        currentState: Bool = true) -> CellDescription?
    {
        //TODO: implementation is missing
        return nil
        
//        let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: currentState)
    }
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSectionWithID sectionID: Int,
        currentState: Bool) -> SectionDescription?
    {
        //TODO: implementation is missing
        return nil
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: Int,
        currentState: Bool = true) -> String?
    {
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            return self.protocolTableView(tableView, titleForHeaderInSection: sectionIndex)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, sectionIDForSectionIndex section: Int, currentState: Bool = true) -> Int?
    {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
    
        return sectionDescription.sectionID
    }
    
    
    func tableView(_ tableView: UITableView, indexOfSectionWithID sectionID: Int, currentState: Bool = true) -> Int?
    {
        if let structure = structureForTable(tableView) {
            if let sectionIndex = structure.indexOfSectionWithID(sectionID, currentState: currentState) {
                return sectionIndex
            }
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, reloadSectionWithID sectionID: Int, rowAnimation: UITableViewRowAnimation = .automatic)
    {
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            
            do {
                try DCExceptionHandler.catchException {
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: rowAnimation)
        }
    }
            catch let error {
                print("An error ocurred: \(error)")
                tableView.reloadData()
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool = true) -> CellDescription?
    {
        let structure = structureForTable(tableView)
        
        if let unwrappedStructure = structure {
            
            if indexPath.section >= unwrappedStructure.dataSourceCells.count {
                return nil
            }
            
            if indexPath.row >= unwrappedStructure.dataSourceCells[indexPath.section].count {
                return nil
            }
            
            return unwrappedStructure.dataSourceCells[indexPath.section][indexPath.row]
        }
        else {
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSection section: Int,
        currentState: Bool = true) -> SectionDescription?
    {
        let structure = structureForTable(tableView)
        if structure == nil {
            return nil
        }
        
        if structure?.dataSourceSections.count == 0 {
            return nil
        }
        
        if section < structure?.dataSourceSections.count {
            if let sectionItem = structure?.dataSourceSections[section] {
                return sectionItem
            }
        }
        
        return nil
    }
    

    
    ////////////////////////////////////////////////////////////////
    // MARK: - Animated table changes
    
    func animateTableChanges(
        _ tableView: UITableView,
        withUpdates: Bool,
        inSections: [Int]? = nil,
        insertAnimation: UITableViewRowAnimation = .automatic,
        deleteAnimation: UITableViewRowAnimation = .automatic)
    {
        guard let structure = structureForTable(tableView) else {
            return
        }
        
        if enableDCTableViewControllerLoging { print("AnimateTableChangesStart") }
        
        let visibleCells = tableView.visibleCells
        let visibleCellsIndexPaths = visibleCells.map { cell in
            tableView.indexPath(for: cell)!
        }
        
        var sectionsToInsert: [Int] = []
        var sectionsToDelete: [Int] = []
        
        var rowsToInsert: [IndexPath] = []
        var rowsToDelete: [IndexPath] = []
        
        let previousSectionIDs = structure.previousDataSourceSections.map { (section) -> Int in
            section.sectionID
        }
        
        let currentSectionIDs = structure.dataSourceSections.map { (section) -> Int in
            section.sectionID
        }
        
        // Result when we delete items from previous array that are not in current array
        let previousSectionIDsFiltration = DCHelper.deleteUnusedPreviousValues(previousArray: previousSectionIDs, currentArray: currentSectionIDs)
        sectionsToDelete = previousSectionIDsFiltration.deletion
        
        // Sequence of insertions that transforms previousArrayFiltration to currentSectionIDs
        let insetions = DCHelper.insertionsInArray(previousArray: previousSectionIDsFiltration.result, currentArray: currentSectionIDs)
        
        sectionsToInsert = insetions.map({ (position: Int, value: Int) in
            return position
        })
        
        
        // Add rows from inserted sections
        for insetion in insetions {
            let currentSectionIndex = self.tableView(tableView, indexOfSectionWithID: insetion.value, currentState: true)
            let cellDescriptions = structure.dataSourceCells[currentSectionIndex!]
            
            for (index, _) in cellDescriptions.enumerated() {
                rowsToInsert.append(IndexPath(row: index, section: insetion.position))
            }
        }
        
        if enableDCTableViewControllerLoging {
            print("    previousSectionIDsFiltration.result \(previousSectionIDsFiltration.result)")
        }
        
        // Process rows for section common for previous and current arrays
        for sectionID in previousSectionIDsFiltration.result {
            if enableDCTableViewControllerLoging {  print("    Processing section '\(sectionID)") }
            
            let previousSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: false)!
            
            let currentSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true)!
            
            if enableDCTableViewControllerLoging {
                print("        previousSectionIndex \(previousSectionIndex), currentSectionIndex \(currentSectionIndex)")
            }
            
            let previousSectionCellIDs = structure.previousDataSourceCells[previousSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            
            if enableDCTableViewControllerLoging {
                print("        previousSectionCellIDs \(previousSectionCellIDs)")
            }
            
            let currentSectionCellIDs = structure.dataSourceCells[currentSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            
            if enableDCTableViewControllerLoging {
                print("        currentSectionCellIDs \(currentSectionCellIDs)")
            }
            
            
            // Row deletion
            // Result when we delete items from previous array that are not in current array
            let previousSectionCellIDsFiltration = DCHelper.deleteUnusedPreviousValues(previousArray: previousSectionCellIDs, currentArray: currentSectionCellIDs)
            
            if enableDCTableViewControllerLoging {
                print("        previousSectionCellIDsFiltration.result \(previousSectionCellIDsFiltration.result)")
                print("        previousSectionCellIDsFiltration.deletion \(previousSectionCellIDsFiltration.deletion)")
            }
            
            let sectionCellsToDelete = previousSectionCellIDsFiltration.deletion.map({ rowIndex in
                IndexPath(row: rowIndex, section: previousSectionIndex)
            })
            
            rowsToDelete += sectionCellsToDelete
            
            //Check row updates
            if withUpdates {
                
                // Find all cells in previous section
                for (previousIndex, previousCellID) in previousSectionCellIDs.enumerated() {
                    // Filter cells for updating
                    if previousSectionCellIDsFiltration.result.index(of: previousCellID) != nil {
                        
                        let previousIndexPath = IndexPath(row: previousIndex, section: previousSectionIndex)
                        
                        // Is the cell visible?
                        if let visibleCellIndex = visibleCellsIndexPaths.index(of: previousIndexPath) {
                            if let cell = visibleCells[visibleCellIndex] as? DCTableViewCellProtocol {
                                
                                // Find indexPath of cell in a new data source
                                for (currentIndex, currentCellID) in currentSectionCellIDs.enumerated() {
                                    if currentCellID == previousCellID {
                                        let currentIndexPath = IndexPath(row: currentIndex, section: currentSectionIndex)
                                        if let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: currentIndexPath) {
                                            //Update visible cell with the new viewModel
                                            if let viewModel = cellDescription.viewModel {
                                                cell.updateCell(viewModel: viewModel, delegate: cellDescription.delegate)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Row insertions
            // Sequence of insertions that transforms previousArrayFiltration to currentSectionIDs
            let sectionCellsToInsert = DCHelper.insertionsInArray(previousArray: previousSectionCellIDsFiltration.result, currentArray: currentSectionCellIDs).map({ insertion in
                IndexPath(row: insertion.position, section: currentSectionIndex)
            })
            if enableDCTableViewControllerLoging {
                print("        sectionCellsToInsert \(DCHelper.displayIndexPaths(sectionCellsToInsert))")
            }
            
            rowsToInsert += sectionCellsToInsert
        }
        
        
        if enableDCTableViewControllerLoging {
            print("    sectionsToDelete: \(sectionsToDelete)")
            print("    rowsToDelete: \(DCHelper.displayIndexPaths(rowsToDelete))")
            print("    sectionsToInsert: \(sectionsToInsert)")
            print("    rowsToInsert: \(DCHelper.displayIndexPaths(rowsToInsert))")
        
            print("AnimateTableChangesEnd")
        }
        

        tableView.beginUpdates()
        
        // 1. remove sections
        for sectionIndex in sectionsToDelete {
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: deleteAnimation)
        }
        
        // 2. remove cells
        tableView.deleteRows(at: rowsToDelete, with: deleteAnimation)
        
    
        // 3. insert sections
        for sectionIndex in sectionsToInsert {
            tableView.insertSections(IndexSet(integer: sectionIndex), with: insertAnimation)
        }
        
        // 4. insert cells
        tableView.insertRows(at: rowsToInsert, with: insertAnimation)
        
        tableView.endUpdates()
        
    }
    
    
}

