

import Foundation

class CommentAPI: BaseAPI<CommentsServiceConfiguration> {
    static let shared = CommentAPI()
    
    func getLovehistory(page: Int,
                        completionHandler: @escaping (Result<CommentsModel, ServiceError>) -> Void) {
        fetchData(configuration: .getLovehistory(page: page),
                  responseType: CommentsModel.self) { result in
            completionHandler(result)
        }
    }
}

