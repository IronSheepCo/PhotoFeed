//
//  UserSettings.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation

class UserSettings
{
    static var ID:String?{
        get{
            return UserDefaults.standard.string(forKey: SettingsKey.UID.rawValue )
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: SettingsKey.UID.rawValue )
        }
    }
}
