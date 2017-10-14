//
//  FirebaseObjects.swift
//  True Pass
//
//  Created by Cliff Panos on 5/30/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


extension RNLocation {
    override var dictionaryForm: [String: Any] {
        return self.dictionaryWithValues(forKeys: ["resources", "recoveryAreas"])
    }
}

extension RNResource {
    override var dictionaryForm: [String: Any] {
        return self.dictionaryWithValues(forKeys: ["title", "content", "poster", "category"])
    }
}

extension RNRecoveryArea {
    override var dictionaryForm: [String: Any] {
        return self.dictionaryWithValues(forKeys: ["title", "content", "poster", "category"])
    }
}


/// A functionally abstract class to manage all Firebases-stored data objects (entities)
extension FirebaseObject {
    
    convenience init(snapshot: DataSnapshot? = nil, _ entity: FirebaseEntity) {

        self.init()
        
        guard let snapshot = snapshot else { return }
        for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
            let key = String(child.key.characters.filter { !" \n\t\r".characters.contains($0) })
            if responds(to: Selector(key)) {
                    setValue(child.value, forKey: key)
            }
        }
    }
    
    @objc var dictionaryForm: [String: Any] {
        return [String: Any]()
    }
}
