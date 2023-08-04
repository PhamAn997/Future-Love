

import Foundation

class HomeAPI: BaseAPI<HomeServiceConfiguration> {
    static let shared = HomeAPI()
    
    func getLovehistory(page: Int,
                        completionHandler: @escaping (Result<HomeModel, ServiceError>) -> Void) {
        fetchData(configuration: .getLovehistory(page: page), 
                  responseType: HomeModel.self) { result in
            completionHandler(result)
        }
    }
    

    func uploadImage(key: String, 
                     name: String,
                     imageData: Data, 
                     completionHandler: @escaping (Result<UploadImage, ServiceError>) -> Void) {
        upload(configuration: .uploadImage(key: key, imageData: imageData),
               name: name,
               responseType: UploadImage.self) { result in
            completionHandler(result)
        }    
    }
}
