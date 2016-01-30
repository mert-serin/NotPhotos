//
//  LoginBrain.swift
//  NotPhotos
//
//  Created by Mert Serin on 28/01/16.
//  Copyright © 2016 Mert Serin. All rights reserved.
//

import Foundation

class LoginBrain{
    
    private var password = String()
    
    init(password:String){
        self.password = password
    }
    
    
    func checkPassword() -> Bool{
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var userPass = userDefaults.objectForKey("password")!
        print("My userpass \(userPass)")
        print("My Pass: \(password)")
        if("\(userPass)" == self.password){
            return true
        }
        return false
    }
}
