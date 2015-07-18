//
//  ShoeSize.swift
//  JSONJam
//
//  Created by Matt Luedke on 7/18/15.
//  Copyright (c) 2015 Matt Luedke. All rights reserved.
//

import JSONJam

public class ShoeSize: JSONJam {
    
    public enum SizeSystem: String {
        case UnitedStates = "US"
        case Europe = "EUR"
        case UnitedKingdom = "UK"
        case Australia = "AUS"
    }
    
    public var size: Int?
    public var sizeSystem: SizeSystem?
    
    override public func propertyMap() {
        map("size", int: &size)
        map("system",
            serializeClosure:{ (inout outgoingParameter: AnyObject?) -> Void in
                outgoingParameter = self.sizeSystem?.rawValue as AnyObject?
            },
            deserializeClosure: { (data: String?) -> Void in
                if let data = data {
                    self.sizeSystem = SizeSystem(rawValue: data)
                }
            }
        )
    }
}
