//
//  DeviceAccountManager.swift
//  sqlite
//
//  Created by Pacoyeung on 4/10/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class DeviceAccountManager: NSObject {
    
    private var accountName:String?
    
    public static let shared:DeviceAccountManager = {
        return DeviceAccountManager()
    }()
    
    private override init()
    {
        super.init()
    }
    
    public func setAccountName(name:String)
    {
        self.accountName = name
    }
    
    public func getAccountName() -> String?
    {
        return self.accountName
    }
    
}
