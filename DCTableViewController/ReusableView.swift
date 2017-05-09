//
//  ReusableView.swift
//  DCTableViewController
//
//  Created by Luca D'Alberti on 8/26/16.
//  Part of code from Allan Barbato
//  Copyright © 2016 STRV. All rights reserved.
//

import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

protocol NibNameRepresentable {
    static var nibName: String { get }
}

extension NibNameRepresentable {
    static var nibName: String { return String(describing: Self.self) }
    static var nib: UINib { return UINib(nibName: Self.nibName, bundle: nil) }
}

extension Identifiable {
    static var identifier: String { return String(describing: Self.self) }
}

protocol ReusableView: Identifiable, NibNameRepresentable {}

extension UITableView {
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCellNib(SmallClipTableCell)
    func registerCellNib<T>(_ cellType: T.Type) where T: ReusableView, T: UITableViewCell {
        self.register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCellClass(SmallClipTableCell)
    func registerCellClass<T>(_ cellType: T.Type) where T: Identifiable, T: UITableViewCell {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // let cell: SmallClipTableCell = tableView.dequeueCell()
    func dequeueCell<T>() -> T where T: UITableViewCell, T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier) as? T else { fatalError("No \(T.identifier) available") }
        return cell
    }
}

extension UICollectionView {
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCell(SmallClipTableCell)
    func registerCellNib<T>(_ cellType: T.Type) where T: ReusableView, T: UICollectionViewCell {
        self.register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCell(SmallClipTableCell)
    func registerCellClass<T>(_ cellType: T.Type) where T: Identifiable, T: UICollectionViewCell {
        self.register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // let cell: SmallClipTableCell = tableView.dequeueCell()
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T: UICollectionViewCell, T: ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("No \(T.identifier) available") }
        return cell
    }
}

extension UIView {
    // Instantiate view from .nib
    // let view.loadFromNib()
    class func loadFromNib<T>() -> T where T: UIView, T: ReusableView {
        guard let view = Bundle.main.loadNibNamed(T.identifier, owner: self, options: nil)!.first as? T else { fatalError("No \(T.identifier) available") }
        return view
    }
    
    class func loadFromNib<T>() -> T! where T: UIView, T: ReusableView {
        guard let view = Bundle.main.loadNibNamed(T.identifier, owner: self, options: nil)!.first as? T else { fatalError("No \(T.identifier) available") }
        return view
    }
}
