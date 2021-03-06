//
//  RCCloudKitDefaultDelegate.swift
//  Utilitati
//
//  Created by Cristian Baluta on 04/01/2018.
//  Copyright © 2018 Baluta Cristian. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

@objc class RCCloudKitDefaultDelegate: NSObject {
    
    var moc: NSManagedObjectContext!
    
    @objc convenience init (moc: NSManagedObjectContext) {
        self.init()
        self.moc = moc
    }
}

extension RCCloudKitDefaultDelegate: RCCloudKitDelegate {
    
    func delete (with recordID: CKRecord.ID) {
        
        let entities = moc.persistentStoreCoordinator!.managedObjectModel.entities
        for entity in entities {
            guard !RCCloudKit.ignoredEntities.contains(entity.name!) else {
                continue
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            request.predicate = NSPredicate(format: "recordName == %@", recordID.recordName as CVarArg)
            if let fetchedObj = (try? self.moc.fetch(request) as? [NSManagedObject])?.first {
                self.moc.delete(fetchedObj)
            }
        }
    }
    
    func save (record: CKRecord, in managedObject: NSManagedObject) -> NSManagedObject {
        
        managedObject.setValue(record.recordID, forKey: "recordID")
        managedObject.setValue(record.recordID.recordName, forKey: "recordName")
        managedObject.setValue(NSNumber(value: true), forKey: "isUploaded")
        
        return managedObject
    }
}
