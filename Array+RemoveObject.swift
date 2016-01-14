//
//  Array+RemoveObject.swift
//
//  Created by areschoug on 20/11/14.
//

//This file should probably not be in this project

import Foundation

extension Array{

    
    mutating func removeObject<T: Equatable>(object: T) -> Bool{
        var index: Int?
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? T {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
            return true
        }
        
        return false
    }
    
}