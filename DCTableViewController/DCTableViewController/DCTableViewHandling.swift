//
//  DCTableViewHandling.swift
//  Rednote
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


enum DCTableViewError: ErrorType {
    case TagIsNotUnique
    case StructureNotFound
    case SectionIndexOutOfBounds
    case RowIndexOutOfBounds
}

protocol DCTableViewHandling: class {

//    associatedtype CellDescription: CellDescribing
//    associatedtype SectionDescription: SectionDescribing
    
    /// Dictionary of table structures. Useful when controller contains more than one table view. TableView.tag is used as a key.
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] { get set }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Table setup
    
    func registerTableView(tableView: UITableView) throws
    
    func createDataSourceForTable(tableView: UITableView)
    
    func structureForTable(table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>?
    
    func tableView(
        tableView: UITableView,
        addSection section: SectionDescription,
        withCells cells: [CellDescription])
    
    func clearPreviousTableState(tableView: UITableView)
    

    ////////////////////////////////////////////////////////////////
    // MARK: - TableView data source methods
    
    func protocolNumberOfSectionsInTableView(tableView: UITableView, currentState: Bool) -> Int
    func protocolTableView(tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool) -> Int
    
    ////////////////////////////////////////////////////////////////
    // Cell
    
//    func protocolTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, controller: UIViewController, currentState: Bool, cellDescription: CellDescription?) -> UITableViewCell
    func protocolTableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    func protocolTableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(tableView: UITableView, titleForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?

    func protocolTableView(tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(tableView: UITableView, titleForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?
    
    func protocolTableView(tableView: UITableView, heightForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, cellDescription: CellDescription?)
    
    func protocolTableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath, cellDescription: CellDescription?)

    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID

    func tableView(
        tableView: UITableView,
        descriptionForCellWithID cellID: Int,
        inSectionWithID sectionID: Int,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        tableView: UITableView,
        descriptionForSectionWithID section: Int,
        currentState: Bool) -> SectionDescription?
    
    func tableView(
        tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: Int,
        currentState: Bool) -> String?
    
    func tableView(
        tableView: UITableView,
        sectionIDForSectionIndex section: Int,
        currentState: Bool) -> Int?
    
    func tableView(
        tableView: UITableView,
        indexOfSectionWithID sectionID: Int,
        currentState: Bool) -> Int?
    
    func tableView(tableView: UITableView, reloadSectionWithID sectionID: Int, rowAnimation: UITableViewRowAnimation)
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: NSIndexPath,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        tableView: UITableView,
        descriptionForSection section: Int,
        currentState: Bool) -> SectionDescription?
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Animated table changes
    
    func animateTableChanges(
        tableView: UITableView,
        withUpdates: Bool,
        inSections: [Int]?,
        insertAnimation: UITableViewRowAnimation,
        deleteAnimation: UITableViewRowAnimation)

}
    
    

extension DCTableViewHandling {
    
    ////////////////////////////////////////////////////////////////
    // Table setup
    
    func registerTableView(tableView: UITableView) throws
    {
        if tableStructures[tableView.tag] != nil {
            throw DCTableViewError.TagIsNotUnique
        }
        
        let structure = DCTableViewStructure<CellDescription, SectionDescription>() //DCTableViewStructure<CellDescription, SectionDescription>()
        
        tableStructures[tableView.tag] = structure
    }

    
    // Check reload parameter
    func createDataSourceForTable(tableView: UITableView)
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
    
    
    func structureForTable(table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>?
    {
        let structure = tableStructures[table.tag]
        
        if structure == nil {
            return nil
        }
        
        return structure!
    }
    
    
    func tableView(
        tableView: UITableView,
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
    
    
    func clearPreviousTableState(tableView: UITableView)
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
    
    func protocolNumberOfSectionsInTableView(tableView: UITableView, currentState: Bool = true) -> Int
    {
        let structure = structureForTable(tableView)
        if structure == nil {
            return 0
        }

        return structure!.getDataSourceSections(currentState).count
    }
    
    
    func protocolTableView(tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool = true) -> Int
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
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat
    {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedEstimatedCellHeight = cellDescription.estimatedCellHeight {
                return unwrappedEstimatedCellHeight(cellDescription: cellDescription, indexPath: indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func protocolTableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat
    {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedCellHeight = cellDescription.estimatedCellHeight {
                return unwrappedCellHeight(cellDescription: cellDescription, indexPath: indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(
        tableView: UITableView,
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
    
    func protocolTableView(tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool = true, sectionDescription: SectionDescription? = nil) -> CGFloat
    {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedHeaderHeight = sectionDescription.headerHeight {
                return unwrappedHeaderHeight(sectionDescription: sectionDescription, section: section)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(
        tableView: UITableView,
        titleForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> String?
    {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
        return sectionDescription.footerTitle
    }
    
    
    func protocolTableView(
        tableView: UITableView,
        heightForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> CGFloat
    {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedFooterHeight = sectionDescription.footerHeight {
                return unwrappedFooterHeight(sectionDescription: sectionDescription, section: section)
            }
        }
        
        return 0
    }
    
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, cellDescription: CellDescription? = nil)
    {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didSelectCell = unwrappedCellDescription.didSelectCell {
            if let unwrappedCell = tableView.cellForRowAtIndexPath(indexPath) {
                didSelectCell(cell: unwrappedCell, cellDescription: unwrappedCellDescription, indexPath: indexPath)
            }
        }
    }
    
    
    func protocolTableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath, cellDescription: CellDescription? = nil)
    {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didDeselectCell = unwrappedCellDescription.didDeselectCell {
            if let unwrappedCell = tableView.cellForRowAtIndexPath(indexPath) {
                didDeselectCell(cell: unwrappedCell, cellDescription: unwrappedCellDescription, indexPath: indexPath)
            }
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID
    
    
    func tableView(
        tableView: UITableView,
        descriptionForCellWithID cellID: Int,
        inSectionWithID sectionID: Int,
        currentState: Bool = true) -> CellDescription?
    {
        //TODO: implementation is missing
        return nil
        
//        let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: currentState)
    }
    
    func tableView(
        tableView: UITableView,
        descriptionForSectionWithID sectionID: Int,
        currentState: Bool) -> SectionDescription?
    {
        //TODO: implementation is missing
        return nil
    }
    
    func tableView(
        tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: Int,
        currentState: Bool = true) -> String?
    {
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            return self.protocolTableView(tableView, titleForHeaderInSection: sectionIndex)
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, sectionIDForSectionIndex section: Int, currentState: Bool = true) -> Int?
    {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
    
        return sectionDescription.sectionID
    }
    
    
    func tableView(tableView: UITableView, indexOfSectionWithID sectionID: Int, currentState: Bool = true) -> Int?
    {
        if let structure = structureForTable(tableView) {
            if let sectionIndex = structure.indexOfSectionWithID(sectionID, currentState: currentState) {
                return sectionIndex
            }
        }
        
        return nil
    }
    
    
    func tableView(tableView: UITableView, reloadSectionWithID sectionID: Int, rowAnimation: UITableViewRowAnimation = .Automatic)
    {
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: rowAnimation)
        }
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: NSIndexPath,
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
        tableView: UITableView,
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
        tableView: UITableView,
        withUpdates: Bool,
        inSections: [Int]? = nil,
        insertAnimation: UITableViewRowAnimation = .Automatic,
        deleteAnimation: UITableViewRowAnimation = .Automatic)
    {
        guard let structure = structureForTable(tableView) else {
            return
        }
        
        print("AnimateTableChangesStart")
        
        var sectionsToInsert: [Int] = []
        var sectionsToDelete: [Int] = []
        
        var rowsToInsert: [NSIndexPath] = []
        var rowsToDelete: [NSIndexPath] = []
        var rowsToUpdate: [NSIndexPath] = []
        
        
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
            
            for (index, _) in cellDescriptions.enumerate() {
                rowsToInsert.append(NSIndexPath(forRow: index, inSection: insetion.position))
            }
        }
        
        print("    previousSectionIDsFiltration.result \(previousSectionIDsFiltration.result)")
        
        // Process rows for section common for previous and current arrays
        for sectionID in previousSectionIDsFiltration.result {
            print("    Processing section '\(sectionID)")
            
            let previousSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: false)!
            
            let currentSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true)!
            
            print("        previousSectionIndex \(previousSectionIndex), currentSectionIndex \(currentSectionIndex)")
            
            let previousSectionCellIDs = structure.previousDataSourceCells[previousSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            print("        previousSectionCellIDs \(previousSectionCellIDs)")
            
            let currentSectionCellIDs = structure.dataSourceCells[currentSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            print("        currentSectionCellIDs \(currentSectionCellIDs)")
            
            
            // Row deletion
            // Result when we delete items from previous array that are not in current array
            let previousSectionCellIDsFiltration = DCHelper.deleteUnusedPreviousValues(previousArray: previousSectionCellIDs, currentArray: currentSectionCellIDs)
            print("        previousSectionCellIDsFiltration.result \(previousSectionCellIDsFiltration.result)")
            print("        previousSectionCellIDsFiltration.deletion \(previousSectionCellIDsFiltration.deletion)")
            
            let sectionCellsToDelete = previousSectionCellIDsFiltration.deletion.map({ rowIndex in
                NSIndexPath(forRow: rowIndex, inSection: previousSectionIndex)
            })
            
            rowsToDelete += sectionCellsToDelete
            
            // Row updates
            if withUpdates {
                var sectionCellsToUpdate: [NSIndexPath] = []
                
                if let previousFilteredSectionIndex = previousSectionIDsFiltration.result.indexOf(sectionID) {
                    for (index, cellID) in previousSectionCellIDs.enumerate() {
                        if previousSectionCellIDsFiltration.result.indexOf(cellID) != nil {
                            
                            sectionCellsToUpdate.append(NSIndexPath(forRow: index, inSection: previousSectionIndex))
                        }
                    }
                    
                    rowsToUpdate += sectionCellsToUpdate
                    
//                    if previousSectionCellIDsFiltration.result.count >= 1 {
//                        let sectionCellsToUpdate = (0...previousSectionCellIDsFiltration.result.count - 1).map({ rowIndex in
//                            NSIndexPath(forRow: rowIndex, inSection: previousFilteredSectionIndex)
//                        })
//                        print("    sectionCellsToUpdate \(DCHelper.displayIndexPaths(sectionCellsToUpdate))")
//                        
//                        
//                    }
                }
            }
            
            // Row insertions
            // Sequence of insertions that transforms previousArrayFiltration to currentSectionIDs
            let sectionCellsToInsert = DCHelper.insertionsInArray(previousArray: previousSectionCellIDsFiltration.result, currentArray: currentSectionCellIDs).map({ insertion in
                NSIndexPath(forRow: insertion.position, inSection: currentSectionIndex)
            })
            print("        sectionCellsToInsert \(DCHelper.displayIndexPaths(sectionCellsToInsert))")
            
            rowsToInsert += sectionCellsToInsert
        }
        
        // Sanity check
//        for indexPath in rowsToDelete + rowsToInsert {
//            if let index = rowsToUpdate.indexOf(indexPath) {
//                rowsToUpdate.removeAtIndex(index)
//            }
//        }
        
        print("    sectionsToDelete: \(sectionsToDelete)")
        print("    rowsToDelete: \(DCHelper.displayIndexPaths(rowsToDelete))")
        print("    rowsToUpdate: \(DCHelper.displayIndexPaths(rowsToUpdate))")
        print("    sectionsToInsert: \(sectionsToInsert)")
        print("    rowsToInsert: \(DCHelper.displayIndexPaths(rowsToInsert))")
        
        print("AnimateTableChangesEnd")
        
        tableView.beginUpdates()
                
        // 1. remove sections
        for sectionIndex in sectionsToDelete {
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: deleteAnimation)
        }
        
        // 2. remove cells
        tableView.deleteRowsAtIndexPaths(rowsToDelete, withRowAnimation: deleteAnimation)
        
        // 3. update cells
        if withUpdates {
            tableView.reloadRowsAtIndexPaths(rowsToUpdate, withRowAnimation: .None)
        }

        // 4. insert sections
        for sectionIndex in sectionsToInsert {
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: insertAnimation)
        }
        
        // 5. insert cells
        tableView.insertRowsAtIndexPaths(rowsToInsert, withRowAnimation: insertAnimation)
        

        tableView.endUpdates()
    }
    
    
}

