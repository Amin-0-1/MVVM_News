//
//  TargetTypes.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import Moya

enum NewsTargets{
    case fetch(category:String,country:String)
}
extension NewsTargets:TargetType{
    var baseURL: URL {
        guard let url = URL(string: Constants.baseUrl) else {fatalError("url is not valid")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetch( _, _):
            return "top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetch(_,_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetch(let category, let country):
            return .requestParameters(parameters: ["apiKey":Constants.apiKey,"country":country,"category":category], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
