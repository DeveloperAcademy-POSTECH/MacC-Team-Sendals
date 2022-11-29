//
//  CurationRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import FirebaseStorage

struct CurationRequest: FirestoreRequest {
    typealias Response = Curation
    let collectionPath = CollectionPath.curations
}

extension CurationRequest {
    // 큐레이션 추가
    func add(curation: Curation) throws {
        try db.collection(collectionPath).document(curation.id).setData(from: curation)
    }
    
    // 큐레이션의 likes 업데이트
    func updateLike(bookstoreID: String, likes: [String]) async throws {
        let querySnapshot = try await db.collection(collectionPath).whereField("bookstoreID", isEqualTo: bookstoreID).getDocuments()
        let document = querySnapshot.documents.first
        try await document?.reference.updateData(["likes" : likes])
    }
    
    func createComment(curationID: String, userID: String ,content: String) throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try db.collection(collectionPath).document(curationID).collection("Comment").document(comment.id).setData(from: comment)
    }
    
    func deleteComment(curationID: String, commentID: String) {
        db.collection(collectionPath).document(curationID).collection("Comment").document(commentID).delete()
    }
}

// 큐레이션이 가진 좋아요 값으로 fetch
//    func fetchLikesCurtions() async throws -> [Curation] {
//        if isLoggedIn() {
//            let user = try await fetchCurrentUser()
//            var likesCurations = [Curation]()
//            for index in user.curationLikes.indices {
//                likesCurations.append(try await fetchCuration(with: user.curstionLikes[index]))
//            }
//            return likesCurations
//        } else {
//            return []
//        }
//    }

    
    func createComment(curationID: String, userID: String ,content: String) throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try db.collection(collectionPath).document(curationID).collection("Comment").document(comment.id).setData(from: comment)
    }
    
    func deleteComment(curationID: String, commentID: String) {
        db.collection(collectionPath).document(curationID).collection("Comment").document(commentID).delete()
    }
    
    func uploadCurationImage(image: UIImage, pathRoot: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { (url, _) in
                guard let url = url else { return }
                completion(url.absoluteString)
            }
        }
    }
    
    func deleteCurationImage(url: String) throws {
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: url)
        httpsReference.delete{ error in
            if let error = error {
                print("error \(error)")
            } else {
                print("delete Success")
            }
        }
                                      
    }
}
