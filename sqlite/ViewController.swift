//
//  ViewController.swift
//  sqlite
//
//  Created by Pacoyeung on 2/23/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,
UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var formList:Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalDatabaseManager.shared.dropTables()
        LocalDatabaseManager.shared.createTables()
        LocalDatabaseManager.shared.insertSampleData()
        
        self.formList = self.getFormList()
        self.setupTableView()
//        print(UIDevice.current.identifierForVendor!.uuidString)
    }
    
    func fakeServerInteraction(completion:@escaping (Bool)->())
    {
        let block = { () -> Bool in
            var formList = WebServiceManager.shared.getFormList()
            formList = LocalDatabaseManager.shared.compareFormList(serverFormList: formList)
            if formList == nil || formList!.count == 0
            {
                return false
            }
            
            for idx in 0..<formList!.count
            {
                var formId:Int?
                if let value = formList![idx]["form_id"] as? String
                {
                    formId = Int(value)
                }else if let value = formList![idx]["form_id"] as? Int
                {
                    formId = value
                }
                if formId == nil
                {
                    continue
                }
                
                let serverFormat = WebServiceManager.shared.getForm(formId:formId!)
                if(serverFormat == nil)
                {
                    continue
                }
                let form = LocalDatabaseManager.shared.jsonToForm(serverFormat: serverFormat!)
                
                //update
                LocalDatabaseManager.shared.deleteForm(formId: form.formId!)
                LocalDatabaseManager.shared.insertForm(form: form)
            }
            return true
        }
        completion(block())
    }
    
    
    func getFormList() -> Array<Dictionary<String,Any>>
    {
        let query = SelectQuery(table: "form_list", constraint: nil, attributes: nil)
        let result = ATSQLiteManager.shared.executeQuery(query: query)
        if result.errNum != nil || result.resultSet == nil
        {
            assert(false)
        }
        return result.resultSet!
    }
    
    private func setupTableView()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        self.tableView.reloadData()
    }
    
    // MARK: - TableView Delegate or DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "form") as! FormViewController
        let form = Form()
        form.jobId = "1"
        if let formId = self.formList[indexPath.row]["form_id"] as? Int
        {
            form.formId = formId
        }
        
        vc.formData = form
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "default")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        }
        
        if let formName = self.formList[indexPath.row]["form_name"] as? String
        {
            cell!.textLabel?.text = "📁 " + formName
        }
        
        return cell!
    }
    
    @IBAction func updateDidPress(_ sender: Any) {
        ActivityIndicatorManager.default.show()
        DispatchQueue.global().async {
            self.fakeServerInteraction(completion: { (success:Bool) in
                self.formList = self.getFormList()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    ActivityIndicatorManager.default.hide()
                }
            })
        }
    }
    
    
    @IBAction func displayCurrentJobTaskDidPress(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "currentJob")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

