//
//  VersionControl.swift
//  version-control-ios
//
//  Created by Luis Mesas on 2/10/15.
//  Copyright (c) 2015 Luis Mesas. All rights reserved.
//

import UIKit

public class VersionControl: NSObject {
    public func start(){
        let mainQueue = NSOperationQueue.mainQueue()
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "handleNetworkOperation:", name: AFNetworkingOperationDidFinishNotification, object: nil)
    }
    
    deinit{
        self.stop()
    }
    
    public func stop(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self);        
    }
    
    public func handleNetworkOperation(notification: NSNotification){
        if let operation = notification.object as? AFHTTPRequestOperation {
            if (operation.response.statusCode != 400) {
                return
            }

            let s = operation.responseString
            if (operation.responseObject.isKindOfClass(NSDictionary)) {
                let dict = operation.responseObject as NSDictionary
                NSNotificationCenter.defaultCenter().postNotificationName(VersionControlNotificationInvalidVersion, object: self, userInfo: dict)

//                let alertView = UIAlertController(title: "AlertView title here", message: "AlertView message comes here", preferredStyle: .Alert)
//                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
}

public let VersionControlNotificationInvalidVersion = "VersionControlInvalidVersion"
