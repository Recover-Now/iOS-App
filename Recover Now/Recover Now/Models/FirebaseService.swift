//
//  FirebaseService.swift
//  True Pass
//
//  Created by Cliff Panos on 5/30/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import Firebase
import FirebaseDatabase

typealias FirebaseObjectCompletion = ((FirebaseObject) -> Void)

enum FirebaseEntity: String {
    case RNUser
    case RNLocation
    case RNResource
    case RNRecoveryArea
}

@objc class FirebaseService : NSObject {
    var reference: DatabaseReference!
    var entity: FirebaseEntity
    
    @objc init(entity: String) {
        self.entity = FirebaseEntity(rawValue: entity) ?? FirebaseEntity.RNUser
        self.reference = Database.database().reference().child(self.entity.rawValue)
        super.init()
    }
    
    func retrieveData(forIdentifier identifier: String, completion: @escaping ((FirebaseObject) -> Void)) {
        reference.child(identifier).observeSingleEvent(of: .value, with: { snapshot in
            let data = self.createTPEntity(from: snapshot)
            completion(data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveList(forIdentifier identifier: String, completion: @escaping ([String: Any]) -> Void) {
        reference.child(identifier).observeSingleEvent(of: .value, with: { snapshot in
            var pairs = [String: Any]()
            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                pairs[child.key] = child.value!
            }
            completion(pairs)
        })
    }
    
    func enterData(forIdentifier identifier: String, data: FirebaseObject) {
        reference.child(identifier).setValue(data.dictionaryForm)
    }
    
    func addChildData(forIdentifier identifier: String, key: String, value: Any) {
        reference.child(identifier).child(key).setValue(value)
    }
    
    func deleteData(forIdentifier identifier: String) {
       reference.child(identifier).removeValue()
    }
    
    func continuouslyObserveData(withIdentifier identifier: String, completion: @escaping ((FirebaseObject) -> Void)) {
        reference.child(identifier).observe(.value, with: { snapshot in
            let data = self.createTPEntity(from: snapshot)
            completion(data) }) { error in
                print(error.localizedDescription)
        }
    }
    
    
    func retrieveAll(completion: @escaping (([FirebaseObject]) -> Void)) {
        reference.observeSingleEvent(of: .value, with: {
            (snapshot) in
                var result : [FirebaseObject] = [FirebaseObject]()
                for child in snapshot.children {
                    result.append(self.createTPEntity(from: child as! DataSnapshot))
                }
                completion(result)
            })
    }
    
    var newIdentifierKey: String {
        let key = reference.childByAutoId().key
        
        return key
    }
    
    private func createTPEntity(from snapshot: DataSnapshot) -> FirebaseObject {
        
        switch entity {
        case FirebaseEntity.RNUser:
            let user = RNUser()
            user.identifier = snapshot.key
            return user
            
        case .RNLocation:
            let affiliation = RNLocation()
            affiliation.identifier = snapshot.key
            //TODO
            return affiliation
            
        case .RNResource:
            let location = RNResource()
            location.identifier = snapshot.key
            return location
            
        case .RNRecoveryArea:
            let pass = RNRecoveryArea()
            pass.identifier = snapshot.key
            return pass
        
        }
    }

}
