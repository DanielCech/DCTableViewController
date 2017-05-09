//
//  DCCellDescription.swift
//  DCTableViewController
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

enum CellType: String, CellTypeDescribing {
    case testCell
    case menuCell
}


////////////////////////////////////////////////////////////////
// Protocols

protocol CellTypeDescribing: RawRepresentable {
    var cellName: String { get }
}

extension CellTypeDescribing {
    var cellName: String {
        if let cellName = self.rawValue as? String {
            return cellName.capitalizeFirstLetter()
        }
        else {
            return ""
        }
    }
}


protocol CellDescribing {
    
    var cellID: Int? { get set }
    var cellType: CellType { get set }
    var viewModel: Any? { get set }
    var delegate: Any? { get set }
    var cellHeight: ((_ cellDescription: Self, _ indexPath: IndexPath) -> CGFloat)? { get set }
    var estimatedCellHeight: ((_ cellDescription: Self, _ indexPath: IndexPath) -> CGFloat)? { get set }
    
    var didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: Self, _ indexPath: IndexPath) -> ())? { get set }
    var didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: Self, _ indexPath: IndexPath) -> ())? { get set }
}

////////////////////////////////////////////////////////////////
// Structs

struct CellDescription: CellDescribing {
    
    var cellID: Int? = nil
    var cellType: CellType
    var viewModel: Any?          //viewModel for cell is any associated value with cell, it can be number, string or class/struct
    var delegate: Any?
    var cellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil
    var estimatedCellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil
    
    var didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> ())? = nil
    var didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> ())? = nil
    
    init(
        cellID: Int? = nil,
        cellType: CellType,
        viewModel: Any? = nil,
        delegate: Any? = nil,
        cellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil,
        estimatedCellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil,
        didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> ())? = nil,
        didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> ())? = nil)
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
