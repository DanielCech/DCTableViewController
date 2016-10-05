//
//  ReusableView.swift
//  Rednote
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
    static var nibName: String { return String(Self) }
    static var nib: UINib { return UINib(nibName: Self.nibName, bundle: nil) }
}

extension Identifiable {
    static var identifier: String { return String(Self) }
}

protocol ReusableView: Identifiable, NibNameRepresentable {}

extension UITableView {
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCellNib(SmallClipTableCell)
    func registerCellNib<T where T: ReusableView, T: UITableViewCell>(cellType: T.Type) {
        self.registerNib(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCellClass(SmallClipTableCell)
    func registerCellClass<T where T: Identifiable, T: UITableViewCell>(cellType: T.Type) {
        self.registerClass(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // let cell: SmallClipTableCell = tableView.dequeueCell()
    func dequeueCell<T where T: UITableViewCell, T: ReusableView>() -> T {
        guard let cell = self.dequeueReusableCellWithIdentifier(T.identifier) as? T else { fatalError("No \(T.identifier) available") }
        return cell
    }
}

extension UICollectionView {
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCell(SmallClipTableCell)
    func registerCellNib<T where T: ReusableView, T: UICollectionViewCell>(cellType: T.Type) {
        self.registerNib(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // tableView.registerCell(SmallClipTableCell)
    func registerCellClass<T where T: Identifiable, T: UICollectionViewCell>(cellType: T.Type) {
        self.registerClass(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    // In case you have a cell called `SmallClipTableCell` you can use this method as
    // let cell: SmallClipTableCell = tableView.dequeueCell()
    func dequeueCell<T where T: UICollectionViewCell, T: ReusableView>(at indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCellWithReuseIdentifier(T.identifier, forIndexPath: indexPath) as? T else { fatalError("No \(T.identifier) available") }
        return cell
    }
}

extension UIView {
    // Instantiate view from .nib
    // let view.loadFromNib()
    class func loadFromNib<T where T: UIView, T: ReusableView>() -> T {
        guard let view = NSBundle.mainBundle().loadNibNamed(T.identifier, owner: self, options: nil)!.first as? T else { fatalError("No \(T.identifier) available") }
        return view
    }
    
    class func loadFromNib<T where T: UIView, T: ReusableView>() -> T! {
        guard let view = NSBundle.mainBundle().loadNibNamed(T.identifier, owner: self, options: nil)!.first as? T else { fatalError("No \(T.identifier) available") }
        return view
    }
}
