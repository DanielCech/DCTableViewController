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
    class func deleteUnusedPreviousValues(previousArray previousArray: [Int], currentArray: [Int], updateIndex: Bool = true) -> (result: [Int], deletion: [Int])
    {
        var previousArrayFiltered: [Int] = []
        var deletion: [Int] = []
        
        var previousIndex = 0
        var currentIndex = 0
        var createdIndex = 0
        
        while true {
            //            print("deleteUnusedPreviousValues: previous \(previousIndex), current \(currentIndex)")
            if previousIndex >= previousArray.count {
                //                print("deleteUnusedPreviousValues: end1")
                break
            }
            
            if currentIndex >= currentArray.count {
                deletion.append(createdIndex)
                previousIndex += 1
                if updateIndex {
                    createdIndex += 1
                }
                continue
            }
            
            //        print("deleteUnusedPreviousValues: previousValue")
            let previousValue = previousArray[previousIndex]
            //        print("deleteUnusedPreviousValues: currentValue")
            let currentValue = currentArray[currentIndex]
            
            if previousValue < currentValue {
                //                print("previous mensi")
                deletion.append(createdIndex)
                previousIndex += 1
                if updateIndex {
                    createdIndex += 1
                }
            }
            else if currentValue < previousValue {
                //                print("current mensi")
                currentIndex += 1
            }
            else {  // Equal
                //                print("stejne")
                previousIndex += 1
                currentIndex += 1
                createdIndex += 1
                previousArrayFiltered.append(currentValue)
            }
        }
        
        //        print("deleteUnusedPreviousValues: deletion \(deletion)")
        
        return (result: previousArrayFiltered, deletion: deletion)
    }

    
    
    class func insertionsInArray(previousArray previousArray: [Int], currentArray: [Int]) -> [(position: Int, value: Int)]
    {
        var toInsert: [(position: Int, value: Int)] = []
        
        var previousIndex = 0
        var currentIndex = 0
        var createdIndex = 0
        
        while true {
            //        print("previous \(previousIndex), current \(currentIndex)")
            let previousEnd = (previousIndex >= previousArray.count)
            let currentEnd = (currentIndex >= currentArray.count)
            
            if previousEnd && currentEnd {
                //            print("end1")
                break
            }
            else if previousEnd && !currentEnd {
                //            print("toInsert1")
                toInsert.append((position: createdIndex, value: currentArray[currentIndex]))
                currentIndex += 1
                createdIndex += 1
            }
            else if !previousEnd && currentEnd {
                //            print("end2")
                break
            }
            else if !previousEnd && !currentEnd {
                
                let previousValue = previousArray[previousIndex]
                let currentValue = currentArray[currentIndex]
                
                if previousValue < currentValue {
                    //                print("previous mensi")
                    toInsert.append((position: createdIndex, value: currentArray[currentIndex]))
                    previousIndex += 1
                    createdIndex += 1
                }
                else if currentValue < previousValue {
                    //                print("current mensi")
                    toInsert.append((position: createdIndex, value: currentArray[currentIndex]))
                    currentIndex += 1
                    createdIndex += 1
                }
                else {  // Equal
                    //                print("stejne")
                    previousIndex += 1
                    currentIndex += 1
                    createdIndex += 1
                }
                
            }
            
        }
        
        return toInsert
    }
    
    
    class func transformArray(previousArray: [Int], currentArray: [Int]) -> (toDelete: [Int], toInsert: [(position: Int, value: Int)])
    {
        let filtration = deleteUnusedPreviousValues(previousArray: previousArray, currentArray: currentArray)
        
        let insetions = insertionsInArray(previousArray: filtration.result, currentArray: currentArray)
        
        return (toDelete: filtration.deletion, toInsert: insetions)
    }
    
    
    class func testTransform(originalArray: [Int], toDelete: [Int], toInsert: [(position: Int, value: Int)]) -> [Int]
    {
        var array = originalArray
        
        for index in toDelete {
            if index > array.count {
                print("deletion problem: \(index), array \(array)")
            }
            else {
                array.removeAtIndex(index)
            }
        }
        
        for insertion in toInsert {
            if insertion.position > array.count {
                print("insetion problem: \(insertion)")
            }
            else {
                array.insert(insertion.value, atIndex: insertion.position)
            }
        }
        
        return array
    }
    
    
    class func displayIndexPaths(indexPaths: [NSIndexPath]) -> [String]
    {
        return indexPaths.map { (indexPath) in
            "<\(indexPath.section), \(indexPath.row)>"
        }
    }
    
}
