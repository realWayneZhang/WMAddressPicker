//
//  AreaModel.swift
//  RefuelNow
//
//  Created by Winson Zhang on 2018/12/19.
//  Copyright © 2018 LY. All rights reserved.
//

import Foundation
import HandyJSON

struct Province: HandyJSON {
    var name: String = ""
    var code: Int = -1
    var cities: [City] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &cities, name: "children")
    }
}

struct City: HandyJSON {
    var name: String = ""
    var code: Int = -1
    var districts: [District] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &districts, name: "children")
    }
}

struct District: HandyJSON {
    var name: String = ""
    var code: Int = -1
}
