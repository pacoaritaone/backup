//
//  WebServiceManager.swift
//  sqlite
//
//  Created by Pacoyeung on 3/20/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceManager: NSObject {
    
    public static let shared:WebServiceManager = {
        return WebServiceManager()
    }()
    private override init()
    {
        super.init()
    }
    
    public func getFormList() -> Array<Dictionary<String,Any>>?
    {
        WebServiceLog(.record)
        
        var formList:Array<Dictionary<String,Any>>?
        let lock = DispatchSemaphore(value: 0)
        self.alamofireRequest(urlStr: "https://vcoin.000webhostapp.com/getFormList.php", method: .get, parameters: nil, header: nil) { (response:DataResponse<Any>?) in
            if(response == nil)
            {
                return
            }
            WebServiceLog(.record, "response not nil passed")
            formList = ((response!.result.value! as? Dictionary<String, Any>)?["form_list"] as? Array<Dictionary<String,Any>>)
            defer {
                lock.signal()
            }
        }
        lock.wait()
        return formList
    }
    
    public func getForm(formId:Int) -> Dictionary<String,Any>?
    {
        WebServiceLog(.record)
        var form:Dictionary<String,Any>?
        let lock = DispatchSemaphore(value: 0)
        
        self.alamofireRequest(urlStr: "https://vcoin.000webhostapp.com/getForm.php?form_id=\(formId)", method: .get, parameters: nil, header: nil) { (response:DataResponse<Any>?) in
            if(response == nil)
            {
                return
            }
            WebServiceLog(.record, "response not nil passed")
            form = ((response!.result.value! as? Dictionary<String, Any>)?["form_layout"] as? Dictionary<String,Any>)
            defer {
                lock.signal()
            }
        }
        lock.wait()
        return form
    }
    
    public func syncForm(dic:Dictionary<String,Any>) -> Bool
    {
        WebServiceLog(.record)
        var sync:Bool = false
        let lock = DispatchSemaphore(value: 0)
        
        self.alamofireRequest(urlStr: "https://vcoin.000webhostapp.com/syncForm.php", method: .post, parameters: dic, header: nil) { (response:DataResponse<Any>?) in
            if(response == nil)
            {
                return
            }
            WebServiceLog(.record, "response not nil passed")
            if let value = (((response!.result.value! as? Dictionary<String, Any>)?["result"] as? Dictionary<String,Any>)?["sync"])
            {
                if let value = self.checkBool(value)
                {
                    sync = value
                }
            }
            defer {
                lock.signal()
            }
        }
        lock.wait()
        return sync
    }
    
    public func syncFormValue(dic:Dictionary<String,Any>) -> Bool
    {
        return false
    }
    
    private func alamofireRequest(urlStr:String, method:HTTPMethod?, parameters:Parameters?, header:HTTPHeaders?, completion:@escaping (DataResponse<Any>?)->())
    {
        WebServiceLog(.record, String(format: "https request: %@", urlStr))
        Alamofire.request(urlStr, method: method!, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(queue: DispatchQueue.global(), options: []) { (response) in
            if !self.checkAlamofireResponse(response)
            {
                completion(nil)
                return
            }
            WebServiceLog(.record, "checkAlamofireResponse passed")
            completion(response)
        }
    }
    
    private func checkAlamofireResponse(_ response:DataResponse<Any>) -> Bool
    {
        var ok:Bool = true
        if response.result.isFailure || response.result.value == nil {
            WebServiceLog(.err, response.error!.localizedDescription)
            ok = false
        }
        return ok
    }
    
    private func checkBool(_ value:Any) -> Bool?
    {
        if let value = value as? String
        {
            if value.lowercased() == "true"
            {
                return true
            }
            return false
        }else if let value = value as? Int
        {
            if value == 1
            {
                return true
            }
            return false
        }else if let value = value as? Bool
        {
            return value
        }
        WebServiceLog(.warn, "checkBool occur unhandled case")
        return nil
    }
    
}
