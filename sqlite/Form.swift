//
//  Form.swift
//  sqlite
//
//  Created by Pacoyeung on 3/6/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class Form: NSObject {
    var jobId:String?
    var formId:Int?
    var formName:String?
    var creationTime:String?
    var modificationTime:String?
    var formFields:Array<Dictionary<String,Any>>?
    var formValues:Array<Dictionary<String,Any>>?
    public override convenience init()
    {
        self.init("", -1, "","","", [], [])
    }
    
    public init(_ jobId:String? = "",_ formId:Int? = -1,_ formName:String? = "",_ creationTime:String?,_ modificationTime:String?,_ formFields:Array<Dictionary<String,Any>> = [],_ formValues:Array<Dictionary<String,Any>> = [])
    {
        self.jobId = jobId
        self.formId = formId
        self.formName = formName
        self.creationTime = creationTime
        self.modificationTime = modificationTime
        self.formFields = formFields
        self.formValues = formValues
    }
}
