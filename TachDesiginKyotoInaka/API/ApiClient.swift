import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ApiClient {
    func get<T: Mappable>(url: String, parameters: [String: String], completion: ((T?, NSError?) -> Void)) {
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL)
            .responseObject { (response: T?, err: NSError?) in
                completion(response, err)
        }
    }
}