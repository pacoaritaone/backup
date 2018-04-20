//
//  FormSubmission.swift
//  sqlite
//
//  Created by Pacoyeung on 3/27/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class FormSubmission: NSObject {
    var transactionId:String?
//    var deviceUUID:String?
//    var deviceLoginEngineer:String?
    var fieldValues:Array<Dictionary<String,Any>>?
    
    public override convenience init()
    {
        self.init("", [])
    }
    
    public init(_ transactionId:String = "",_ fieldValues:Array<Dictionary<String,Any>> = [])
    {
        self.transactionId = transactionId
        self.fieldValues = fieldValues
    }
    
}
