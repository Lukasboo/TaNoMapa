//
//  OTMClient.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 13/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import Foundation

class OTMClient : NSObject {
    
    var session = URLSession.shared

    override init() {
        super.init()
    }
    
    func  getUserData(_ method: String, result: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/" + UserDefaults.standard.string(forKey: "userID")!)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ParseClient.ParseParametersValues.APIKey, forHTTPHeaderField: ParseClient.ParseParameterKeys.APIKey)
        request.addValue(ParseClient.ParseParametersValues.ApplicationID, forHTTPHeaderField: ParseClient.ParseParameterKeys.ApplicationID)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            func sendError(_ error: String) {
                print(error)
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
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            do {
                var parsedResult: AnyObject! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! AnyObject
                    print(parsedResult)
                    print(parsedResult["first_name"])
                    print(parsedResult["last_name"])
                    result(parsedResult, nil)
                } catch {
                    let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
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
        print(parsedResult!)
        
        completionHandlerForConvertData(parsedResult!, nil)
    }
    
    func login(_ method: String, username: String, password: String, result: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
            print(username)
            print(password)
            let request = NSMutableURLRequest(url: otmURLFromParameters())
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                
                func sendError(_ error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    result(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                }
                
                if !Functions.isInternetAvailable() {
                    sendError("Sem conexão com a Internet!")
                    return
                }
                
                if error != nil {
                    return
                }
                
                if (response as? HTTPURLResponse)?.statusCode == 403 {
                    sendError("Invalid credentials")
                    return
                }
                else {
                    sendError("Your request returned a status code other than 2xx!")
                    return
                }
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!) //pegar key aqui
                
                var parsedResult: AnyObject! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! AnyObject
                    let session = (parsedResult!["session"]!)! as! AnyObject
                    let userID = session["id"]! as! String
                    
                    UserDefaults.standard.set(userID as! String, forKey: "userID")
                    result(parsedResult, nil)
                } catch {
                    sendError("Could not parse the data as JSON: '\(data)'")
                }
                result(response, nil)
                
            }
            task.resume()
            
            return task
        
    }
    
    func logout(completion: @escaping(Bool)->()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion(true)
        }
        task.resume()
    }
    
    private func otmURLFromParameters() -> URL {
        var components = URLComponents()
        components.scheme = OTMClient.Constants.ApiScheme
        components.host = OTMClient.Constants.ApiHost
        components.path = OTMClient.Constants.ApiPath 
        return components.url!
    }
        
    // MARK: Shared Instance
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
}
