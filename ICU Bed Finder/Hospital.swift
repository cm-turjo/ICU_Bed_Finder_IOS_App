//
//  Hospital.swift
//  ICU Bed Finder
//
//  Created by Abdulla Rahman on 24/11/23.
//

import Foundation

class Hospital {
    var name: String
    var totalBed: Int
    var availableBed: Int
    var street: String
    var district: String
    var postalCode: Int
    var contact: Int
    var id : String = ""
    
    
    init(name: String, totalBed: Int, availableBed: Int, street: String, district: String, postalCode: Int, contact: Int) {
        self.name = name
        self.totalBed = totalBed
        self.availableBed = availableBed
        self.street = street
        self.district = district
        self.postalCode = postalCode
        self.contact = contact
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "name": name,
            "totalBed": totalBed,
            "availableBed": availableBed,
            "street": street,
            "district": district,
            "postalCode": postalCode,
            "contact": contact
        ]
    }
}
