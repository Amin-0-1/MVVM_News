//
//  OnBoardingElement.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import Foundation

enum OBImages:String{
    case details
    case surfing
    case search
}

struct OnBoardingElement:CustomStringConvertible{
    static let _NUM = 3
    let imageName:String
    let title:String
    var description: String{
        switch self.imageName {
        case "details":
            return "you can find out the details of the news and its main sources"
        case "surfing":
            return "you can surfing the navigating though out all the latest news all over the world"
        case "search":
            return "you cans seach for everything you want"
        default:
            return ""
        }
    }
}
