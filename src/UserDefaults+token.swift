//
//  Created by Cristian Baluta on 09/04/2017.
//  Copyright © 2017 Imagin soft. All rights reserved.
//

import Foundation
import CloudKit

private let kChangeTokenKey = "RCCloudKit-ServerChangeToken"

public extension UserDefaults {
    
    var serverChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: kChangeTokenKey) as? Data else {
                return nil
            }
            guard let token = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken else {
                return nil
            }
            
            return token
        }
        set {
            if let token = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: token)
                self.set(data, forKey: kChangeTokenKey)
                self.synchronize()
            } else {
                self.removeObject(forKey: kChangeTokenKey)
            }
        }
    }
}
