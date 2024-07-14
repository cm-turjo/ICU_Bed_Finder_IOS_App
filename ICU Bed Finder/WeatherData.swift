//
//  WeatherData.swift
//  api3
//
//  Created by Turjo-Mac on 11/27/23.
//

import Foundation
struct WeatherData:Codable
{
    let location:LocationData
    let current:CurrentData
}
