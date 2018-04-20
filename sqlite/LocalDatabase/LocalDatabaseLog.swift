//
//  LocalDatabaseLog.swift
//  sqlite
//
//  Created by Pacoyeung on 3/20/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import Foundation

public enum LocalDatabaseLogType:Int{
    case record
    case debug
    case err
    case warn
}

public func LocalDatabaseLog(_ type:LocalDatabaseLogType,_ logStr:String? = "",_ file:String? = #file,_ function:String? = #function,_ line:Int? = #line)
{
    #if !DEBUG
        if(type == Log.debug)
        {
            return
        }
    #endif
    
    var logo = ""
    
    switch (type) {
    case .debug:
        logo = "📱"
        break
    case .record:
        logo = "📝"
        break
    case .warn:
        logo = "⚠️"
        break;
    case .err:
        logo = "🚫"
        break
    }
    
    NSLog(logo+"%@ %@ at line:%d ~>\n%@", URL(string: file!)!.lastPathComponent, function!, line!, logStr!)
}
