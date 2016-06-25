//
//  CountryData.swift
//  CCCountrySelector
//
//  Created by Chad on 10/17/15.
//  Copyright © 2015 Chad. All rights reserved.
//

import UIKit

struct CountryData  {
    let name:String
    let countryCode:String
    let phoneCode:String
    
    
    init(name:String,countryCode:String,phoneCode:String){
        self.phoneCode = name
        self.name = name
        self.countryCode = countryCode
    }
}
