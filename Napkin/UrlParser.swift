//
//  UrlParser.swift
//  Napkin
//
//  Created by Cameron Hotchkies on 3/12/15.
//  Copyright (c) 2015 Srs Biznas. All rights reserved.
//

import Foundation

protocol UrlParser {
    init(rawUrl:String)
    func arguments() -> [[String:String]]
}

class UrlParserImpl : UrlParser {
    var rawUrl:String
    var args:[[String: String]]
    
    required init(rawUrl:String) {
        self.rawUrl = rawUrl
        
        let urlComponents = rawUrl.componentsSeparatedByString("?")
        
        if (urlComponents.count == 2) {
            var argumentString = urlComponents[1]
            var arguments = argumentString.componentsSeparatedByString("&")
            
            let actualArgs = arguments.map {
                (var pair) -> [String: String] in
                var components = pair.componentsSeparatedByString("=")
                return [
                    "key": components[0].stringByRemovingPercentEncoding!,
                    "value":components[1].stringByRemovingPercentEncoding!]
            }
            
            self.args = actualArgs
        } else {
            self.args = []
        }

    }
    
    func arguments() -> [[String:String]] {
        return args
    }
    
}
