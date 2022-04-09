//
//  MyUserDefaults.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import Foundation

protocol MyUserDefaultsInterface{
    static func getValue(forkKey key:UDKeys)->Any?
}
enum UDKeys:String{
    case isFirstInit
    case country
    case interests
    case business,entertainment,general,health,science,sports,technology
}
class MyUserDefaults{
    let shared = MyUserDefaults()
    private static let userDefaults:UserDefaults = UserDefaults.standard
    
    private init(){}
    static func getValue(forKey key:UDKeys)->Any?{
        let val = userDefaults.value(forKey:key.rawValue)
        return val
    }
    static func set(value val:Any,forKey key:UDKeys){
        userDefaults.set(val, forKey: key.rawValue)
    }
}
