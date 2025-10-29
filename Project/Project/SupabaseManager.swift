//
//  SupabaseManager.swift
//  Project
//
//  Created by VnPaz on 3/12/25.
//

import Foundation
import Supabase


// manager, service, repogitory
class SupabaseManager {
    
    static let shared : SupabaseManager = SupabaseManager()
    
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient(supabaseURL: URL(string: "https://umjbakvveldbisvtpcwf.supabase.co")!, supabaseKey: supabaseKey)
    }
    
    // SupabaseManager.shared.register
    func register(email: String, password: String, nickName: String, gender: String) async throws {
        
        
        
        let createdUser = try await client.auth.signUp(
          email: email,
          password: password
        )
        
        struct CreateUserRequest: Encodable {
          let id: UUID
          let nickName: String
          let gender: String
        }

        let createUserRequest = CreateUserRequest(id: createdUser.user.id, nickName: nickName, gender: gender)

        try await client
          .from("users")
          .insert(createUserRequest)
          .execute()

        
    }
    
}
