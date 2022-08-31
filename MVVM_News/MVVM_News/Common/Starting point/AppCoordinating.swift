//
//  Coordinating.swift
//  MVVM_News
//
//  Created by Amin on 22/05/2022.
//

import Foundation
import UIKit

protocol AppCoordinating{
    func start()
}

struct AppCoordinator:AppCoordinating{
    
    private let window:UIWindow?
    
    init(window:UIWindow?){
        self.window = window
    }
    func start() {
        let navigationController = UINavigationController()
        let onBoarding = 
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
}
