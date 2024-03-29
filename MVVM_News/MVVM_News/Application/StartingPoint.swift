//
//  StartingPoint.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import Foundation
import UIKit

class StartingPoint{
    private static var window:UIWindow?
    static func isFirstInit(window:UIWindow)->Bool{
        self.window = window
        guard let _ = MyUserDefaults.getValue(forKey: .isFirstInit) else {return true}
        return false
    }
    static func navigateToHome(){
        let vc:UIViewController = HomeVC()
        guard let window = window else {return}
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationItem.largeTitleDisplayMode = .automatic
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
//    private static func finishInit(){
//        MyUserDefaults.set(value: true, forKey: .isFirstInit)
//    }
    
}

