//
//  CalendarVars.swift
//  miniprojetios
//
//  Created by maryem on 4/13/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import Foundation
let date = Date()
let calendar = Calendar.current
let day = calendar.component(.day,from:date)
let weekday = calendar.component(.weekday,from:date)-1
var month = calendar.component(.month,from:date)-1
var year = calendar.component(.year, from:date)
