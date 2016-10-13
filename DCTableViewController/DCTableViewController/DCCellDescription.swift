//
//  DCCellDescription.swift
//  Rednote
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

enum CellType: String {
    case TestCell
    case MenuCell
}


////////////////////////////////////////////////////////////////
// Protocols

protocol CellDescribing {
    
    var cellID: Int? { get set }
    var cellType: CellType { get set }
    var viewModel: Any? { get set }
    var delegate: Any? { get set }
    var cellHeight: ((cellDescription: Self, indexPath: NSIndexPath) -> CGFloat)? { get set }
    var estimatedCellHeight: ((cellDescription: Self, indexPath: NSIndexPath) -> CGFloat)? { get set }
    
    var didSelectCell: ((cell: UITableViewCell, cellDescription: Self, indexPath: NSIndexPath) -> ())? { get set }
    var didDeselectCell: ((cell: UITableViewCell, cellDescription: Self, indexPath: NSIndexPath) -> ())? { get set }
}

////////////////////////////////////////////////////////////////
// Structs

struct CellDescription: CellDescribing {
    
    var cellID: Int? = nil
    var cellType: CellType
    var viewModel: Any?          //viewModel for cell is any associated value with cell, it can be number, string or class/struct
    var delegate: Any?
    var cellHeight: ((cellDescription: CellDescription, indexPath: NSIndexPath) -> CGFloat)? = nil
    var estimatedCellHeight: ((cellDescription: CellDescription, indexPath: NSIndexPath) -> CGFloat)? = nil
    
    var didSelectCell: ((cell: UITableViewCell, cellDescription: CellDescription, indexPath: NSIndexPath) -> ())? = nil
    var didDeselectCell: ((cell: UITableViewCell, cellDescription: CellDescription, indexPath: NSIndexPath) -> ())? = nil
    
    init(
        cellID: Int? = nil,
        cellType: CellType,
        viewModel: Any? = nil,
        delegate: Any? = nil,
        cellHeight: ((cellDescription: CellDescription, indexPath: NSIndexPath) -> CGFloat)? = nil,
        estimatedCellHeight: ((cellDescription: CellDescription, indexPath: NSIndexPath) -> CGFloat)? = nil,
        didSelectCell: ((cell: UITableViewCell, cellDescription: CellDescription, indexPath: NSIndexPath) -> ())? = nil,
        didDeselectCell: ((cell: UITableViewCell, cellDescription: CellDescription, indexPath: NSIndexPath) -> ())? = nil)
    {
        self.cellID = cellID
        self.cellType = cellType
        self.viewModel = viewModel
        self.delegate = delegate
        self.cellHeight = cellHeight
        self.estimatedCellHeight = estimatedCellHeight
        self.didSelectCell = didSelectCell
        self.didDeselectCell = didDeselectCell
    }
}
