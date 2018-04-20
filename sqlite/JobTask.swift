//
//  JobTask.swift
//  sqlite
//
//  Created by Pacoyeung on 4/10/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class JobTask: NSObject {

    public var jobId:String
    public var formIds:Array<String>
    
    public override convenience init()
    {
        self.init("", [])
    }
    
    public init(_ jobId:String,_ formIds:Array<String>)
    {
        self.jobId = jobId
        self.formIds = formIds
    }
}
