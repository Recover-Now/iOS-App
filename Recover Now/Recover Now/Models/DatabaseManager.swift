//
//  DatabaseManager.swift
//
//  Created by Cliff Panos on 5/12/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import Firebase
import FirebaseDatabase
import Foundation

///Contains high-level methods for retrieving & modifying data from the FirebaseDatabase as well as interacting with Core Data
class DatabaseManager {
    
    static let shared = DatabaseManager()
    static var isConnected: Bool = false
    static var reference: DatabaseReference!
    internal var connectedReference: DatabaseReference!
    
    init() {
        print("Monitoring for connection")
        let database = Database.database()
        DatabaseManager.reference = database.reference()
        connectedReference = database.reference(withPath: ".info/connected")
        connectedReference.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected to Database!")
                DatabaseManager.isConnected = true
            } else {
                print("Not connected to Database!")
                DatabaseManager.isConnected = false
            }
        })
    }
    
    
}

