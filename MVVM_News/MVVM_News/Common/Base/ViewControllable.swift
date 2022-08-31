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
        self.view.subviews.forEach{$0.isUserInteractionEnabled = false}
    }
    func hideLoading(){
        self.view.hideAllToasts()
        self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        self.view.isUserInteractionEnabled = true
        self.view.subviews.forEach{$0.isUserInteractionEnabled = true}

    }
}
