//
//  Router.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import Foundation
import Moya

enum Router {
    case login(query: LoginQuery)
}

extension Router: TargetType {
    var baseURL: URL {
        <#code#>
    }
    
    var path: String {
        <#code#>
    }
    
    var method: Moya.Method {
        <#code#>
    }
    
    var task: Moya.Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
