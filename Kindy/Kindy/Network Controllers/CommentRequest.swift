//
//  CommentRequest.swift
//  Kindy
//
//  Created by rbwo on 2022/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommentRequest: FirestoreRequest {
    typealias Response = Comment
    let collectionPath = CollectionPath.comments
}

extension CommentRequest {
    /// 댓글 추가
    func add(curationID: String, userID: String ,content: String, count: Int) async throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try await db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).document(comment.id)
            .setData(
                [
                    "id" : comment.id,
                    "userID" : comment.userID,
                    "content" : comment.content,
                    "createdAt" : comment.createdAt
                ]
            )
        
        try await CurationRequest().updateCommentCount(curationID: curationID, count: count)
    }
    
    /// 댓글 삭제
    func delete(curationID: String, commentID: String, count: Int) async throws {
        try await db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).document(commentID).delete()
        try await CurationRequest().updateCommentCount(curationID: curationID, count: count)
    }
}

extension CommentRequest {
    /// 처음에 모든 댓글 불러오는 함수
    func fetch(id: String) async throws -> [Comment] {
        let querySnapshot = try await db.collection(CollectionPath.curations).document(id).collection(collectionPath).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
        return responses
    }
    
    ///  댓글의 바뀐 부분만 불러오는 함수
    func update(curationID: String, completion: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).addSnapshotListener { querySnapshot, error in
            completion(querySnapshot,error)
        }
    }
}
