//
//  FormViewController.swift
//  sqlite
//
//  Created by Pacoyeung on 3/2/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit
import XLForm

class FormViewController: XLFormViewController {

    public var formData:Form?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.formData == nil || self.formData!.jobId == nil || self.formData!.formId == nil
        {
            return
        }
        
        self.initFormDataWith(jobId:self.formData!.jobId!, formId: self.formData!.formId!)
        self.buildFormLayout()
    }
    
    
    private func initFormDataWith(jobId:String, formId:Int)
    {
        self.formData = LocalDatabaseManager.shared.showForm(jobId: jobId,formId: formId)
    }

    func buildFormLayout()
    {
        
        let form:XLFormDescriptor = XLFormDescriptor(title: self.formData!.formName)
        let section:XLFormSectionDescriptor = XLFormSectionDescriptor.formSection()
        var row:XLFormRowDescriptor? = nil
        
        for idx in 0..<self.formData!.formFields!.count
        {
            let field = self.formData!.formFields![idx]
            var fieldQuestionId = field["question_id"] as? Int
            let fieldName = field["field_name"] as? String
            let fieldType = field["type"] as? String
            var multiple = field["multiple"] as? Int
            
            
            if(fieldQuestionId == nil || fieldName == nil || fieldType == nil || multiple == nil)
            {
                return
            }
            
            row = XLFormRowDescriptor(tag: String(fieldQuestionId!), rowType: self.mapXLFormRowType(fieldType: fieldType!, multiple: (multiple == 1)), title: fieldName!)
            
            let options = field["options"] as? Array<Dictionary<String,Any>>
            if options != nil {
                var arr:Array<String> = []
                for idx in 0..<options!.count
                {
                    if let str = options![idx]["value"] as? String{
                        arr.append(str)
                    }
                }
                row?.selectorOptions = arr
            }
            section.addFormRow(row!)
            
        }
        
        if (self.formData!.formFields!.count > 0)
        {
            row = XLFormRowDescriptor(tag: "submit", rowType: XLFormRowDescriptorTypeButton, title: "Submit")
            row?.action.formBlock = {(form) in
                self.submitForm()
            }
            section.addFormRow(row!)
        }
        
        form.addFormSection(section)
        self.form = form
    }
    
    func mapXLFormRowType(fieldType:String, multiple:Bool) -> String
    {
        var type = ""
        switch fieldType.uppercased() {
        case "TEXT":
            type = XLFormRowDescriptorTypeText
            break
        case "RADIO":
            if(multiple)
            {
                type = XLFormRowDescriptorTypeMultipleSelector
            }else
            {
                type = XLFormRowDescriptorTypeSelectorPush
            }
            break
        
        case "DROPDOWN":
            type = XLFormRowDescriptorTypeSelectorPickerViewInline
            break
        default:
            type = XLFormRowDescriptorTypeText
            break
        }
        return type
    }
    
    func submitForm()
    {
        if self.formData == nil
        {
            return
        }

        var values:Array<Dictionary<String,Any>> = []

        for idx in 0..<self.formData!.formFields!.count
        {
            var dic:Dictionary<String,Any> = [:]

            let field = self.formData!.formFields![idx]
            let fieldId = field["id"] as? Int

            if let value = self.form.formRow(withTag: String(fieldId!))?.value {
                if let value = value as? String
                {
                    dic[String(fieldId!)] = value
                }
                if let arr = value as? Array<String>
                {
                    dic[String(fieldId!)] = arr
                }
            }
            values.append(dic)
        }
        self.formData!.formValues = values
        if(!self.saveToLocalStorage())
        {
            return
        }
        
    }
    
    func saveToLocalStorage() -> Bool
    {
        if self.formData == nil
        {
            return false
        }
        if(!LocalDatabaseManager.shared.insertFormValue(form: self.formData!))
        {
            return false
        }
        let formId = String(format:"%d",self.formData!.formId!)
        
        if(!LocalDatabaseManager.shared.markJobTaskAsSubmitted(jobId: self.formData!.jobId!, formId: formId))
        {
            return false
        }
        return true
    }
}
