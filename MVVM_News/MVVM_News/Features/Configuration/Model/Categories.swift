//
//  Categories.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import Foundation

enum Categories:String,CaseIterable,Codable{
    case business,entertainment,general,health,science,sports,technology
    
    static func getAllCategories()->[String]{
        return Self.allCases.map{$0.rawValue}
    }
}
