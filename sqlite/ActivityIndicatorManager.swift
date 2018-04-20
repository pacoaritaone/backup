//
//  ActivityIndicatorManager.swift
//  FYP
//
//  Created by Pacoyeung on 1/8/18.
//  Copyright © 2018 Pacoyeung. All rights reserved.
//

import UIKit

class ActivityIndicatorManager: NSObject {

    private static var instance:ActivityIndicatorManager?
    private static var kMask:String = "loading"
    private var loading:UIActivityIndicatorView!
    private var mask:UIView!
    open static let `default`:ActivityIndicatorManager = {
        if(ActivityIndicatorManager.instance == nil)
        {
            return ActivityIndicatorManager()
        }else{
            return instance!
        }
    }()
    
    private override init()
    {
        super.init()
        self.setupLoadingScreen()
        ActivityIndicatorManager.instance = self
    }
    
    public func show()
    {
        if(!self.mask.isDescendant(of: UIApplication.shared.keyWindow!))
        {
            UIApplication.shared.keyWindow?.addSubview(mask)
        }
        self.loading.startAnimating()
    }
    
    public func hide()
    {
        if(self.mask.isDescendant(of: UIApplication.shared.keyWindow!))
        {
            self.mask.removeFromSuperview()
        }
        self.loading.stopAnimating()
    }
    
    private func setupLoadingScreen()
    {
        self.loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.mask = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        self.mask.addSubview(self.loading)
        self.mask.backgroundColor = UIColor.clear
        self.loading.center = self.mask.center
    }
    
}
