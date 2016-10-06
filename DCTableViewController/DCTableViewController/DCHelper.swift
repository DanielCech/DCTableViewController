//
//  DCHelper.swift
//  DCTableViewController
//
//  Created by Dan on 06.10.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class DCHelper: NSObject {

    // Values in arrays are ascending
    class func deleteUnusedPreviousValues(previousArray previousArray: [Int], currentArray: [Int]) -> (result: [Int], toDelete: [Int])
    {
        var previousArrayFiltered: [Int] = []
        var deletion: [Int] = []
        
        var previousIndex = 0
        var currentIndex = 0
        
        while true {
            
            if previousIndex >= previousArray.count {
                break
            }
            
            if currentIndex >= currentArray.count {
                deletion.append(previousIndex)
                previousIndex += 1
                break
            }
            
            let previousValue = previousArray[previousIndex]
            let currentValue = currentArray[currentIndex]
            
            if previousValue < currentValue {
                deletion.append(previousIndex)
                previousIndex += 1
            }
            else if currentValue < previousValue {
                currentIndex += 1
            }
            else {  // Equal
                previousIndex += 1
                currentIndex += 1
                previousArrayFiltered.append(currentValue)
            }
        }
        
        return (result: previousArrayFiltered, toDelete: deletion)
    }
    
    
    class func insertionsInArray(previousArray previousArray: [Int], currentArray: [Int]) -> [(position: Int, value: Int)]
    {
        var toInsert: [(position: Int, value: Int)] = []
        
        var previousIndex = 0
        var currentIndex = 0
        
        while true {
            print("previous \(previousIndex), current \(currentIndex)")
            let previousEnd = (previousIndex >= previousArray.count)
            let currentEnd = (currentIndex >= currentArray.count)
            
            if previousEnd && currentEnd {
                print("end1")
                break
            }
            else if previousEnd && !currentEnd {
                print("toInsert1")
                toInsert.append((position: previousIndex, value: currentArray[currentIndex]))
                currentIndex += 1
            }
            else if !previousEnd && currentEnd {
                print("end2")
                break
            }
            else if !previousEnd && !currentEnd {
                
                let previousValue = previousArray[previousIndex]
                let currentValue = currentArray[currentIndex]
                
                if previousValue < currentValue {
                    print("previous mensi")
                    toInsert.append((position: previousIndex, value: currentArray[currentIndex]))
                    previousIndex += 1
                }
                else if currentValue < previousValue {
                    print("current mensi")
                    toInsert.append((position: previousIndex, value: currentArray[currentIndex]))
                    currentIndex += 1
                }
                else {  // Equal
                    print("stejne")
                    previousIndex += 1
                    currentIndex += 1
                }
                
            }
            
        }
        
        return toInsert
    }
    
    
    class func transformArray(previousArray: [Int], currentArray: [Int]) -> (toDelete: [Int], toInsert: [(position: Int, value: Int)])
    {
        let filtration = DCHelper.deleteUnusedPreviousValues(previousArray: previousArray, currentArray: currentArray)
        
        let insetions = DCHelper.insertionsInArray(previousArray: filtration.result, currentArray: currentArray)
        
        return (toDelete: filtration.toDelete, toInsert: insetions)
    }
    
    
    class func displayIndexPaths(indexPaths: [NSIndexPath]) -> [String]
    {
        return indexPaths.map { (indexPath) in
            "<\(indexPath.section), \(indexPath.row)>"
        }
    }
    
}
