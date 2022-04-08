//
//  ViewControllable.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import UIKit

protocol ViewControllable : UIViewController{
    func showLoading()
    func hideLoading()
}

extension ViewControllable{
    func showLoading(){
        self.view.makeToastActivity(.center)
        self.view.isUserInteractionEnabled = false
    }
    func hideLoading(){
        self.view.hideAllToasts()
        self.view.isUserInteractionEnabled = true
    }
}
