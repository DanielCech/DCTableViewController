//
//  DCSectionDescription.swift
//  DCTableViewController
//
//  Created by Dan on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

////////////////////////////////////////////////////////////////
// Protocols

protocol SectionDescribing {
    
    var sectionID: Int { get set }
    var viewModel: Any? { get set }         //Check whether it is useful?
    
    var headerTitle: String? { get set }
    var headerHeight: ((sectionDescription: Self, section: Int) -> CGFloat)? { get set }
    
    var footerTitle: String? { get set }
    var footerHeight: ((sectionDescription: Self, section: Int) -> CGFloat)? { get set }

}


////////////////////////////////////////////////////////////////
// Structs

struct SectionDescription: SectionDescribing {
    var sectionID: Int
    var viewModel: Any? = nil
    
    var headerTitle: String? = nil
    var headerHeight: ((sectionDescription: SectionDescription, section: Int) -> CGFloat)? = nil
    var estimatedHeaderHeight: ((sectionDescription: SectionDescription, section: Int) -> CGFloat)? = nil
    
    var footerTitle: String? = nil
    var footerHeight: ((sectionDescription: SectionDescription, section: Int) -> CGFloat)? = nil
    
    init(
        sectionID: Int,
        viewModel: Any? = nil,
        
        headerTitle: String? = nil,
        headerHeight: ((sectionDescription: SectionDescription, section: Int) -> CGFloat)? = nil,
        
        footerTitle: String? = nil,
        footerHeight: ((sectionDescription: SectionDescription, section: Int) -> CGFloat)? = nil
        )
    {
        self.sectionID = sectionID
        self.viewModel = viewModel
        
        self.headerTitle = headerTitle
        self.headerHeight = headerHeight
        
        self.footerTitle = footerTitle
        self.footerHeight = footerHeight
    }
}

