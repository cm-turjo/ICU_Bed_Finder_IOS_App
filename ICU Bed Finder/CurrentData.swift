//
//  CurrentData.swift
//  api3
//
//  Created by Turjo-Mac on 11/27/23.
//

import Foundation
struct CurrentData:Codable
{
    let last_updated:String
    let temp_c:Float
    let wind_kph:Float
    let humidity:Int
    //newly added
    let feelslike_c:Float
    let precip_mm:Float
    let cloud:Float
    let wind_dir:String
    let vis_km:Float
    
}
