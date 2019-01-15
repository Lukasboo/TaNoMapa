//
//  ParseStudents.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import Foundation

struct ParseStudents : Codable {
    let results : [ParseStudentsResults]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([ParseStudentsResults].self, forKey: .results)
    }
    
}

struct ParseStudentsResults : Codable {
    let objectId : String?
    let mediaURL : String?
    let firstName : String?
    let longitude : Double?
    let uniqueKey : String?
    let latitude : Double?
    let mapString : String?
    let lastName : String?
    let createdAt : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        
        case objectId = "objectId"
        case mediaURL = "mediaURL"
        case firstName = "firstName"
        case longitude = "longitude"
        case uniqueKey = "uniqueKey"
        case latitude = "latitude"
        case mapString = "mapString"
        case lastName = "lastName"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try values.decodeIfPresent(String.self, forKey: .objectId)
        mediaURL = try values.decodeIfPresent(String.self, forKey: .mediaURL)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        uniqueKey = try values.decodeIfPresent(String.self, forKey: .uniqueKey)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        mapString = try values.decodeIfPresent(String.self, forKey: .mapString)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
    
}
