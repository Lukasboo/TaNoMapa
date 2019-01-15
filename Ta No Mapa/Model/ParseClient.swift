//
//  ParseClient.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod2(_ method: String, result: @escaping (_ result: ParseStudents?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: parseURLFromParameters([:], withPathExtension: "/classes/StudentLocation"))
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ParseClient.ParseParametersValues.APIKey, forHTTPHeaderField: ParseClient.ParseParameterKeys.APIKey)
        request.addValue(ParseClient.ParseParametersValues.ApplicationID, forHTTPHeaderField: ParseClient.ParseParameterKeys.ApplicationID)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                result(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
                        
            let decoder = JSONDecoder()
            do {
                let gardens = try decoder.decode(ParseStudents.self, from: data)
                result(gardens, nil)
            } catch {
                print("erro")
            }
        }
        
        task.resume()
        return task
    }
    
    func addLocation(_ method: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, result: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100?order=-updatedAt")!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ParseClient.ParseParametersValues.APIKey, forHTTPHeaderField: ParseClient.ParseParameterKeys.APIKey)
        request.addValue(ParseClient.ParseParametersValues.ApplicationID, forHTTPHeaderField: ParseClient.ParseParameterKeys.ApplicationID)
        
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                result(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            if error != nil {
                return
            }
                        
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            result(response, nil)
            
        }
        task.resume()
        
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult!, nil)
    }
    
    
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme =  ParseClient.ParseConstants.ApiScheme
        components.host = ParseClient.ParseConstants.ApiHost
        components.path = ParseClient.ParseConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: value as! String)
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
   
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
