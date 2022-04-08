//
//  CountriesCodes.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import Foundation

enum SupportedCountryCodes:String,CaseIterable{
    static let _ID = "Supported Countries"
    case us,gb,ru,it,jp,ae,ra,ta,ub,eb,rc,ac,hc,nc,oc,uc,zd,ee,gf,rg,bg,rh,kh,ui,di,kr,lt,lv,ma,mx,my,ng,nl,no,nz,ph,pl,pt,ro,rs,sa,se,sg,si,sk,th,tr,tw,ua,ve,za
    
    static func getAllCodes() ->[String]{
        return Self.allCases.map{$0.rawValue}
    }
}
