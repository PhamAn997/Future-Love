

import Foundation

enum Enviroment {
    case staging
    case production
}

extension Enviroment {
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://sakaivn.online/"
        case .production:
            return "https://sakaivn.online/"
        }
    }
    
    var imgAPIURL: String {
        switch self {
        case .staging:
            return "https://api.imgbb.com/"
        case .production:
            return "https://api.imgbb.com/"
        }
    }
    
    var IPURL: String {
        switch self {
        case .staging:
            return "https://ipinfo.io/json"
        case .production:
            return "https://ipinfo.io/json"
        }
    }
}
