

import Foundation

enum CommentsServiceConfiguration {
    case getLovehistory(page: Int)

}

extension CommentsServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        case .getLovehistory:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getLovehistory(let page):
            return "lovehistory/pageComment/\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLovehistory:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLovehistory:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var data: Data? {
        switch self {
        default:
            return nil
        }
    }
}
