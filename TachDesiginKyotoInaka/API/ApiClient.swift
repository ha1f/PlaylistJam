import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ApiClient {
    func get<T: Mappable>(url: String, parameters: [String: String], completion: ((T?) -> Void)) {
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL)
            .responseObject({ (response: T?, err: ErrorType?) in
                completion(response)
            })
    }
}