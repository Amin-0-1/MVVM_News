//
//  StartingPoint.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import Foundation

class StartingPoint{
    static func isFirstInit()->Bool{
//        guard let _ = MyUserDefaults.getValue(forKey: .isFirstInit) else {finishInit();return true}
//        return false
        return true
    }
    private static func finishInit(){
        MyUserDefaults.set(value: true, forKey: .isFirstInit)
    }
}

