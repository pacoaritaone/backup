//
//  CurrentJobViewController.swift
//  sqlite
//
//  Created by Pacoyeung on 4/10/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class CurrentJobViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = DeviceAccountManager.shared.getAccountName()
        if name == nil
        {
            return
        }
        let jobTasks = LocalDatabaseManager.shared.currentJobTask(deviceAccountName: name!)
        if jobTasks == nil
        {
            return
        }
        //print output
        var str = ""
        for jobtask in jobTasks!
        {
            str = str + "Job Id: " + jobtask.jobId + "\n"
            str = str + "Form Id: "
            for formId in jobtask.formIds
            {
                str = str + formId + " "
            }
            str = str + "\n"
        }
        self.textView.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
