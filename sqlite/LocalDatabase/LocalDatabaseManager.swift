//
//  LocalDatabaseManager.swift
//  sqlite
//
//  Created by Pacoyeung on 3/2/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class LocalDatabaseManager: NSObject {

    public static var shared:LocalDatabaseManager = {
        return LocalDatabaseManager()
    }()
    
    private override init()
    {
        super.init()
    }
    
    public func createTables()
    {
        var sqls:Array<String> = []
        
        sqls.append(
            """
        CREATE TABLE IF NOT EXISTS form_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        form_id INTEGER NOT NULL,
        form_name TEXT,
        creation_time TEXT,
        modification_time TEXT)
        """
        )
        
        sqls.append(
            """
        CREATE TABLE IF NOT EXISTS form_layout (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        form_id INTEGER /*REFERENCES form_list(form_id)*/ NOT NULL,
        question_id INTEGER NOT NULL,
        sequence_no INTEGER NOT NULL,
        type TEXT CHECK( type IN ('TEXT','RADIO','DROPDOWN')),
        field_name TEXT,
        multiple INTEGER CHECK( multiple IN (0,1))
        )
        """
        )
        
        sqls.append(
            """
        CREATE TABLE IF NOT EXISTS form_layout_choice (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        form_id INTEGER /*REFERENCES form_list(form_id)*/ NOT NULL,
        question_id INTEGER NOT NULL,
        sequence_no INTEGER NOT NULL,
        value TEXT)
        """
        )
        
        sqls.append(
            """
        CREATE TABLE IF NOT EXISTS form_value (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        form_in_job_id INTEGER NOT NULL,
        form_id INTEGER /*REFERENCES form_list(form_id)*/ NOT NULL,
        question_id INTEGER NOT NULL,
        field_value TEXT
        )
        """)
        
        sqls.append(
            """
        CREATE TABLE IF NOT EXISTS form_in_job (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        job_id INTEGER NOT NULL,
        form_id INTEGER NOT NULL,
        engineer TEXT,
        submit INTEGER DEFAULT 0
        )
        """
        )
        
        for sql in sqls {
            let query = GenericQuery(query: sql)
            let result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return
            }
        }

    }
    
    public func dropTables()
    {
        let lock = DispatchSemaphore(value: 0)
        ATSQLiteManager.shared.executeTransactionQueryBlock({ () -> (Bool?) in
            
            var query = GenericQuery(query: "DROP TABLE IF EXISTS form_list")
            var result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = GenericQuery(query: "DROP TABLE IF EXISTS form_layout")
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = GenericQuery(query: "DROP TABLE IF EXISTS form_layout_choice")
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = GenericQuery(query: "DROP TABLE IF EXISTS form_value")
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = GenericQuery(query: "DROP TABLE IF EXISTS form_in_job")
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            return false
        }, {
            lock.signal()
        })
        lock.wait()
    }
    
    public func showTables()
    {
        
        var query = SelectQuery(table: "form_list", constraint: nil, attributes: nil)
        var result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return
        }
        print(result.resultSet!)
        
        query = SelectQuery(table: "form_layout", constraint: nil, attributes: nil)
        result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return
        }
        print(result.resultSet!)
        
        query = SelectQuery(table: "form_layout_choice", constraint: nil, attributes: nil)
        result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return
        }
        print(result.resultSet!)
        
        query = SelectQuery(table: "form_value", constraint: nil, attributes: nil)
        result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return
        }
        print(result.resultSet!)
        
        query = SelectQuery(table: "form_in_job", constraint: nil, attributes: nil)
        result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return
        }
        print(result.resultSet!)
    }
    
    public func insertSampleData()
    {
        let lock = DispatchSemaphore(value: 0)
        ATSQLiteManager.shared.executeTransactionQueryBlock({ () -> (Bool?) in
            var query = InsertQuery(table: "form_list", attributes: ["form_id","form_name","creation_time","modification_time"], values: ["1","cooling","2018-03-09 00:00:00","2018-03-09 00:00:00"])
            if query == nil
            {
                return true
            }
            var result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            
            query = InsertQuery(table: "form_layout", attributes: ["form_id","question_id","sequence_no","type","field_name","multiple"], values: ["1","1","1", "TEXT","Name","0"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(result.errNum != nil)
            {
                return true
            }
            
            query = InsertQuery(table: "form_layout", attributes: ["form_id","question_id","sequence_no","type","field_name","multiple"], values: ["1", "2", "2", "RADIO","Gender","0"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            //male
            query = InsertQuery(table: "form_layout_choice", attributes: ["form_id","question_id","sequence_no","value"], values: ["1","2","1","Male"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            //female
            query = InsertQuery(table: "form_layout_choice", attributes: ["form_id","question_id","sequence_no","value"], values: ["1","2","2","Female"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            //radio
            query = InsertQuery(table: "form_layout", attributes: ["form_id","question_id","sequence_no","type","field_name","multiple"], values: ["1", "3", "3", "RADIO","Food","1"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            //Apple
            query = InsertQuery(table: "form_layout_choice", attributes: ["form_id","question_id","sequence_no","value"], values: ["1","3","1","Apple"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            //Orange
            query = InsertQuery(table: "form_layout_choice", attributes: ["form_id","question_id","sequence_no","value"], values:["1","3","2","Orange"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            
            //Table:form_in_job
            query = InsertQuery(table: "form_in_job", attributes: ["job_id","form_id","engineer"], values: ["1","1","paco"])
            if query == nil
            {
                return true
            }
            result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            
            
            return false
        },{
            lock.signal()
        })
        lock.wait()
    }
    
    public func deleteForm(formId:Int)
    {
        let lock = DispatchSemaphore(value: 0)
        ATSQLiteManager.shared.executeTransactionQueryBlock({ () -> (Bool?) in
            
            let constraint = "form_id == \(formId)"
            
            var query = DeleteQuery(table: "form_layout_choice", constraint: constraint)
            var result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = DeleteQuery(table: "form_layout", constraint: constraint)
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            
            query = DeleteQuery(table: "form_list", constraint: constraint)
            result = ATSQLiteManager.shared.executeQuery(query: query)
            if(!self.checkATSQLiteResult(query: query, result: result))
            {
                return true
            }
            return false
        },{
            lock.signal()
        })
        lock.wait()
    }
    
    public func insertForm(form:Form)
    {
        //var formListId:NSInteger?
        let formId:String? = String(form.formId!)
        let formName:String? = form.formName
        let creationTime:String? = form.creationTime
        let modificationTime:String? = form.modificationTime
        let fields:Array<Dictionary<String,Any>>? = form.formFields
        
        if(formId == nil || formName == nil || creationTime == nil || modificationTime == nil || fields == nil)
        {
            return
        }
        let lock = DispatchSemaphore(value: 0)
        ATSQLiteManager.shared.executeTransactionQueryBlock({ () -> (Bool?) in
            
            let query = InsertQuery(table: "form_list", attributes: ["form_id","form_name","creation_time","modification_time"], values: [formId!, formName!, creationTime!,modificationTime!])
            if query == nil
            {
                return true
            }
            let result = ATSQLiteManager.shared.executeQuery(query: query!)
            if(!self.checkATSQLiteResult(query: query!, result: result))
            {
                return true
            }
            
            for idx in 0..<fields!.count
            {
                let field = fields![idx]
                
                let fieldName = field["field_name"] as? String
                
                var sequenceNo:String?
                if let value = field["sequence_no"] as? String
                {
                    sequenceNo = value
                }else if let value = field["sequence_no"] as? Int
                {
                    sequenceNo = String(value)
                }
                
                var questionId:String?
                if let value = field["question_id"] as? String
                {
                    questionId = value
                }else if let value = field["question_id"] as? Int
                {
                    questionId = String(value)
                }
                var type:String?
                if let value = field["type"] as? String
                {
                    type = value
                }
                var options:Array<Dictionary<String,Any>>?
                
                if let value = field["options"] as? Array<Dictionary<String,Any>>
                {
                    options = value
                }
                
                var multiple:String?
                if let value = field["multiple"] as? String
                {
                    multiple = value
                }else if let value = field["multiple"] as? Int
                {
                    multiple = String(value)
                }
                
                if (fieldName == nil || questionId == nil || sequenceNo == nil || type == nil || multiple == nil)
                {
                    return true
                }
                
                let query = InsertQuery(table: "form_layout", attributes: ["form_id","question_id","sequence_no","type","field_name","multiple"], values: [formId!, questionId!, sequenceNo!, type!,fieldName!,multiple!])
                if(query == nil)
                {
                    return true
                }
                let result = ATSQLiteManager.shared.executeQuery(query: query!)
                if(!self.checkATSQLiteResult(query: query!, result: result))
                {
                    return true
                }
                
                if(options == nil)
                {
                    continue
                }
                
                for idx in 0..<options!.count
                {
                    
                    let option = options![idx]
                    
                    var optionName:String?
                    if let value = option["value"] as? String
                    {
                        optionName = value
                    }
                    
                    var sequenceNo:String?
                    if let value = option["sequence_no"] as? String
                    {
                        sequenceNo = value
                    }else if let value = field["sequence_no"] as? Int
                    {
                        sequenceNo = String(value)
                    }
                    
                    if(sequenceNo == nil || optionName == nil)
                    {
                        return true
                    }
                    
                    let query = InsertQuery(table: "form_layout_choice", attributes: ["form_id","question_id","sequence_no","value"], values: [formId!, questionId!, sequenceNo!, optionName!])
                    if(query == nil) {
                        return true
                    }
                    let result = ATSQLiteManager.shared.executeQuery(query: query!)
                    if(!self.checkATSQLiteResult(query: query!, result: result))
                    {
                        return true
                    }
                }
            }
            return false
        },{
            lock.signal()
        })
        lock.wait()
    }
    
    public func getFormName(formId:Int) -> String?
    {
        let constraint = "form_id == \(formId)"
        let query = SelectQuery(table: "form_list", constraint: constraint, attributes: ["form_name"])
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        return result.resultSet![0]["form_name"] as? String
    }
    
    public func showForm(jobId:String, formId:Int) -> Form?
    {
        let form = Form()
        form.jobId = jobId
        form.formId = formId

        let constraint = "form_id == '\(formId)'"
        
        let query = SelectQuery(table: "form_list", constraint: constraint, attributes: nil)
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        
        if let value = result.resultSet![0]["form_name"] as? String
        {
            form.formName = value
        }
        if let value = result.resultSet![0]["creation_time"] as? String
        {
            form.creationTime = value
        }
        if let value = result.resultSet![0]["modification_time"] as? String
        {
            form.modificationTime = value
        }
        
        let retData = self.dbFormLayout(formId: formId)
        
        if(retData == nil)
        {
            return nil
        }
        
        var _retData = retData!
        for idx in 0..<_retData.count
        {
            var dic = _retData[idx]
            var formId:String?
            if let value = dic["form_id"] as? String
            {
                formId = value
            }else if let value = dic["form_id"] as? Int
            {
                formId = String(value)
            }
            
            var questionId:String?
            if let value = dic["question_id"] as? String
            {
                questionId = value
            }else if let value = dic["question_id"] as? Int
            {
                questionId = String(value)
            }
            if(formId == nil || questionId == nil)
            {
                continue
            }
            
            let type:String = dic["type"] as! String
            switch(type)
            {
            case "TEXT":
                break
            case "RADIO", "DROPDOWN":
                _retData[idx]["options"] = self.formLayoutOptions(Int(formId!)!, Int(questionId!)!)
                break
            default: break
            }
            
        }
        form.formFields = _retData
        return form
    }
    
    
    public func formLayoutOptions(_ formId:Int,_ questionId:Int) -> Array<Dictionary<String,Any>>?
    {
        var constraint = "form_id == \(formId) AND question_id == \(questionId)"
        let order = "ORDER BY sequence_no"
        
        constraint = constraint + " " + order
        
        let query = SelectQuery(table: "form_layout_choice", constraint: constraint, attributes: nil)
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        return result.resultSet
    }
    
    
    public func formDataToJson(form:Form) -> String
    {
        if(form.jobId == nil || form.formId == nil || form.formId! <= 0)
        {
            return ""
        }
        
        let _form = self.showForm(jobId: form.jobId! ,formId: form.formId!)
        
        if(_form == nil)
        {
            return ""
        }
        
        form.formName = _form!.formName
        form.formFields = _form!.formFields
        form.creationTime = _form!.creationTime
        form.modificationTime = _form!.modificationTime
        
        if(form.formFields!.count <= 0)
        {
            return ""
        }
        
        var serverFormat:Dictionary<String,Any> = [:]
        
        serverFormat["form_id"] = form.formId!
        serverFormat["form_name"] = form.formName!
        serverFormat["creation_time"] = form.creationTime
        serverFormat["modification_time"] = form.modificationTime
        serverFormat["total_field_count"] = form.formFields!.count
        serverFormat["fields"] = form.formFields
        
        let jsonData:Data = try! JSONSerialization.data(withJSONObject: serverFormat, options: [])
        var jsonStr = String(bytes: jsonData, encoding: String.Encoding.utf8)
        
        if jsonStr == nil
        {
            jsonStr = ""
        }
        return jsonStr!
    }
    
    public func jsonToForm(serverFormat:Dictionary<String,Any>) -> Form
    {
        let form = Form()

        if let formId = serverFormat["form_id"] as? Int
        {
            form.formId = formId
        }
        if let formName = serverFormat["form_name"] as? String
        {
            form.formName = formName
        }
        if let value = serverFormat["creation_time"] as? String
        {
            form.creationTime = value
        }
        if let value = serverFormat["modification_time"] as? String
        {
            form.modificationTime = value
        }
        
        if let formFields = serverFormat["fields"] as? Array<Dictionary<String,Any>>
        {
            form.formFields = formFields
        }
        return form
        
    }
    
    public func jsonToForm(jsonStr:String) -> Form?
    {
        let jsonData = jsonStr.data(using: .utf8)
        let serverFormat = (try? JSONSerialization.jsonObject(with: jsonData!, options: [])) as? Dictionary<String,Any>
        if serverFormat == nil
        {
            return nil
        }
        return self.jsonToForm(serverFormat: serverFormat!)
    }
    
    public func formListToJson() -> String
    {
        let forms = self.dbFormList()
        if forms == nil
        {
            return ""
        }
        
        var newforms:Array<Dictionary<String,Any>> = []
        for idx in 0..<forms!.count
        {
            var dic:Dictionary<String,Any> = [:]
            dic["form_id"] = forms![idx]["form_id"]
            dic["form_name"] = forms![idx]["form_name"]
            dic["creation_time"] = forms![idx]["creation_time"]
            dic["modification_time"] = forms![idx]["modification_time"]
            newforms.append(dic)
        }
        
        var serverFormat:Dictionary<String,Any> = [:]
        serverFormat["form_list"] = newforms
        
        let jsonData:Data = try! JSONSerialization.data(withJSONObject: serverFormat, options: .prettyPrinted)
        var jsonStr = String(bytes: jsonData, encoding: String.Encoding.utf8)
        if jsonStr == nil
        {
            jsonStr = ""
        }
        return jsonStr!
    }
    
    public func dbFormList() -> Array<Dictionary<String,Any>>?
    {
        let query = SelectQuery(table: "form_list", constraint: nil, attributes: nil)
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        return result.resultSet
    }
    
    public func dbFormLayout(formId:Int) -> Array<Dictionary<String,Any>>?
    {
        var constraint = "form_id == '\(formId)'"
        let order = "ORDER BY sequence_no"
        
        constraint = constraint + " " + order
        
        let query = SelectQuery(table: "form_layout", constraint: constraint, attributes: nil)
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        return result.resultSet
    }
    
    public func compareFormList(serverFormList:Array<Dictionary<String,Any>>?) -> Array<Dictionary<String,Any>>?
    {
        if(serverFormList == nil)
        {
            return nil
        }
        
        var needUpdateforms:Array<Dictionary<String,Any>> = []
        var localFormList = self.dbFormList()
        
        if localFormList == nil
        {
            return nil
        }
        
        for idx in 0..<serverFormList!.count
        {
            let serverForm = serverFormList![idx]
            var serverFormId:Int?
            if let value = serverForm["form_id"] as? Int {
                serverFormId = value
            }
            var localForm:Dictionary<String,Any>?
            for idx in 0..<localFormList!.count
            {
                if let localFormId = localFormList![idx]["form_id"] as? Int
                {
                    if serverFormId == localFormId
                    {
                        localForm = localFormList![idx]
                        break
                    }
                }
            }
            
            if localForm == nil
            {
                //need update
                needUpdateforms.append(serverFormList![idx])
                continue
            }
            
            let serverLastModified = serverForm["modification_time"] as? String
            let localLastModified = localForm!["modification_time"] as? String
            
            if(serverLastModified == nil || localLastModified == nil)
            {
                continue
            }
            
            let result = self.compareLastDate(first: serverLastModified!, second: localLastModified!)
            
            if(result == -1)
            {
                continue
            }else if(result == 0)
            {
                continue
            }else if(result == 2)
            {
                continue
            }
            //need update
            needUpdateforms.append(serverFormList![idx])
        }
        
        if(needUpdateforms.count == 0)
        {
            return nil
        }
        
        return needUpdateforms
    }
    
    public func compareFormList(jsonStr:String) -> Array<Dictionary<String,Any>>?
    {
        let serverFormat = self.jsonToDictionary(jsonStr: jsonStr)
        
        if(serverFormat == nil || serverFormat!["form_list"] == nil)
        {
            return nil
        }
        
        let serverFormList = serverFormat!["form_list"] as? Array<Dictionary<String,Any>>
        if(serverFormat == nil || serverFormList!.count == 0)
        {
            return nil
        }
        
        return self.compareFormList(serverFormList: serverFormList!)
    }
    
    public func jsonToDictionary(jsonStr:String) -> Dictionary<String,Any>?
    {
        let jsonData = jsonStr.data(using: .utf8)
        
        if(jsonData == nil)
        {
            return nil
        }
        
        var serverFormat:Dictionary<String,Any>?
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            if let jsonObject = jsonObject as? Dictionary<String,Any>
            {
                serverFormat = jsonObject
            }
        } catch {
            return nil
        }
        return serverFormat
    }
    
    public func dictionaryToJson(dic:Dictionary<String,Any>) -> String
    {
        var jsonData:Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        } catch {
            return ""
        }
        
        if jsonData == nil
        {
            return ""
        }
        let jsonStr = String(bytes: jsonData!, encoding: String.Encoding.utf8)
        if jsonStr == nil
        {
            return ""
        }
        return jsonStr!
    }
    
    public func compareLastDate(first:String, second:String) -> Int
    {
        let formatter =  DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let _first = formatter.date(from: first)
        let _second = formatter.date(from: second)
        
        if(_first == nil || _second == nil)
        {
            return -1
        }
        if(_first! == _second!)
        {
            return 0
        }else if(_first! > _second!)
        {
            return 1
        }else
        {
            return 2
        }
        
    }
    
    public func insertFormValue(form:Form) -> Bool
    {
        var success = true
        
        if(form.jobId == nil || form.formId == nil || form.formValues == nil)
        {
            success = false
            return success
        }
        
        if(form.formValues!.count < 0)
        {
            success = false
            return success
        }
        let lock = DispatchSemaphore(value: 0)
        ATSQLiteManager.shared.executeTransactionQueryBlock({ () -> (Bool?) in
            
            for idx in 0..<form.formValues!.count
            {
                if form.formValues![idx].keys.count == 0
                {
                    continue
                }
                let questionId:String = form.formValues![idx].keys.first!
                let fieldValues = form.formValues![idx][questionId]
                
                if let value = fieldValues as? String
                {
                    let query = InsertQuery(table: "form_value",
                                            attributes: ["form_in_job_id","form_id","question_id","field_value"],
                                            values: ["\(form.jobId!)", "\(form.formId!)", questionId, value])
                    if(query == nil)
                    {
                        success = false
                        return true
                    }
                    let result = ATSQLiteManager.shared.executeQuery(query: query!)
                    if result.errNum != nil{
                        success = false
                        return true
                    }
                }
                
                if let multipleValue = fieldValues as? Array<String>
                {
                    for idx in 0..<multipleValue.count
                    {
                        let value = multipleValue[idx]
                        let query = InsertQuery(table: "form_value",
                                                attributes: ["form_in_job_id","form_id","question_id","field_value"],
                                                values: ["\(form.jobId!)", "\(form.formId!)", questionId, value])
                        if query == nil
                        {
                            success = false
                            return true
                        }
                        let result = ATSQLiteManager.shared.executeQuery(query: query!)
                        if result.errNum != nil
                        {
                            success = false
                            return true
                        }
                    }
                }
            }
            return false
        }) {
            lock.signal()
        }
        lock.wait()
        return success
    }
    
    public func getSubmissionForm(transactionId:String) -> FormSubmission?
    {
        
        let formSubmission = FormSubmission()
        
        formSubmission.transactionId = transactionId

        formSubmission.fieldValues = LocalDatabaseManager.shared.getSubmissionFormValues(transactionId: transactionId)
        
        return formSubmission
    }
    
    public func getSubmissionFormValues(transactionId:String) -> Array<Dictionary<String,Any>>?
    {
        let query = SelectQuery(table: "form_value", constraint: "form_in_job_id == '\(transactionId)'", attributes: ["form_id", "question_id","field_value"])
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return nil
        }
        return result.resultSet
    }
    
    public func deleteSubmissionForm(transactionId:String) -> Bool
    {
        let query = DeleteQuery(table: "form_value", constraint: "form_in_job_id == \(transactionId)")
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        
        if(!self.checkATSQLiteResult(query: query, result: result))
        {
            return false
        }
        return true
    }
    
    
    public func markJobTaskAsSubmitted(jobId:String, formId:String) -> Bool
    {
        let query = UpdateQuery(table: "form_in_job", constraint: "job_id == '\(jobId)' AND form_id == '\(formId)'", attributes: ["submit"], values: ["1"])
        if query == nil
        {
            return false
        }
        let result = ATSQLiteManager.shared.executeQuery(query: query!)
        if result.errNum != nil
        {
            return false
        }
        return true
    }
    
    public func syncJobTask(deviceAccountName:String) -> Array<JobTask>?
    {
        return nil
    }
    
    public func currentJobTask(deviceAccountName:String) -> Array<JobTask>?
    {
        let query = SelectQuery(table: "form_in_job", constraint: "engineer == '\(deviceAccountName)' AND submit == '0'", attributes: ["job_id"])
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if result.errNum != nil { return nil }
        if result.resultSet == nil { return nil }
        
        var jobTasks:Array<JobTask> = []
        
        for dic in result.resultSet!
        {
            if dic["job_id"] == nil{ continue }
            let jobTask = JobTask()
            if let value = dic["job_id"] as? String
            {
                jobTask.jobId = value
            }else if let value = dic["job_id"] as? Int
            {
                jobTask.jobId = String(format: "%d", value)
            }
            let query = SelectQuery(table: "form_in_job", constraint: "engineer == '\(deviceAccountName)' AND job_id == '\(jobTask.jobId)'", attributes: ["form_id"])
            let result = ATSQLiteManager.shared.executeQuery(query: query)
            if result.errNum != nil || result.resultSet == nil {continue}
            for dic in result.resultSet!
            {
                if let value = dic["form_id"] as? String
                {
                    jobTask.formIds.append(value)
                }else if let value = dic["form_id"] as? Int
                {
                    jobTask.formIds.append(String(format:"%d", value))
                }
            }
            jobTasks.append(jobTask)
        }
        return jobTasks
    }
    
    private func checkATSQLiteResult(query:QueryString, result:QueryResult) -> Bool
    {
        var checkResultSet = false
        if query.isKind(of: SelectQuery.self)
        {
            checkResultSet = true
        }
        
        if(result.errNum != nil || (result.resultSet == nil && checkResultSet))
        {
            WebServiceLog(.err, String(format: "checkATSQLiteResult fail %@", query.string!))
            return false
        }
        return true
    }
}




