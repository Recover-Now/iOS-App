//
//  FirebaseStorage.swift
//  True Pass
//
//  Created by Cliff Panos on 6/14/17.
//  Copyright © 2017 Clifford Panos. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

@objc class FirebaseStorage: NSObject {
    
    ///The shared FirebaseStorage object
    static let shared = FirebaseStorage()
    let storage: Storage
    let storageRef: StorageReference
    
    let TPProfilePictureMaxSize: Int64 = 4*1024*1024
    let TPPassPictureMaxSize: Int64 = 4*1024*1024
    
    override init() {
        storage = Storage.storage()
        storageRef = storage.reference()
        super.init()
    }
    
    var usersDirectoryReference: StorageReference {
        return storageRef.child("\(FirebaseEntity.RNUser)")
    }

    var pngMetadata: StorageMetadata {
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        return metadata
    }
    
    func uploadImage(data: Data, for entity: FirebaseEntity, withIdentifier identifier: String, _ handler: @escaping (StorageMetadata?, Error?) -> Void) {
        let childRef = storageRef.child(entity.rawValue).child(identifier)
        childRef.putData(data, metadata: pngMetadata) { metadata, error in
            handler(metadata, error) }
    }
    
    func retrieveImageData(for identifier: String, entity: FirebaseEntity, handler: @escaping (Data?, Error?) -> Void) {
        let reference = storageRef.child(entity.rawValue).child(identifier)
        reference.getData(maxSize: TPPassPictureMaxSize, completion: handler)
    }
    
    
    func retrieveProfilePicture(for uid: String, _ handler: @escaping (Data?, Error?) -> Void) {
        let childRef = usersDirectoryReference.child(uid)
        childRef.getData(maxSize: TPProfilePictureMaxSize, completion: handler)
    }
    
    func retrieveProfilePictureForCurrentUser(_ handler: @escaping (Data?, Error?) -> Void) {
        if let currentID = Accounts.userIdentifier {
            retrieveProfilePicture(for: currentID, handler)
        }
    }
    
    func deleteImage(forEntity entity: FirebaseEntity, withIdentifier identifier: String) {
        guard entity == .RNUser || entity == .RNLocation || entity == .RNResource else {
            print("This type of entity does not have image data")
            return
        }
        storageRef.child(entity.rawValue).child(identifier).delete(completion: nil)
    }
    
    
}
