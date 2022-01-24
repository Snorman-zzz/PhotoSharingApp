//
//  AuthManager.swift
//  A-List
//
//  Created by Norman Yuan on 11/14/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import FirebaseAuth
import Foundation
import Alamofire

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    let auth = Auth.auth()
    
    enum AuthError: Error {
        case newUserCreation
        case signInFailed
    }
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void) {
            DatabaseManager.shared.findUser(with: email) { [weak self] user in
                guard let user = user else {
                    completion(.failure(AuthError.signInFailed))
                    return
                }
                
                self?.auth.signIn(withEmail: email, password: password) { (result, error) in
                    guard result != nil, error == nil else {
                        completion(.failure(AuthError.signInFailed))
                        return
                    }
                    
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    completion( .success(user))
                }
            }

        }
    
    public func signUp(register: RegisterModel) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                } catch {
                print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func uroraSignIn(urora: UroraModel) {
        let headers: HTTPHeaders = [
                    "Authorization": "Basic ZTI3MjUzMTBhMzU1ZDE0MDhlYzFlMTBkOjNiZjMwNjYwNjY0ZGIwZjhjNTgyODM2Mw==",
                    "Accept": "application/json",
                    "Content-Type": "application/json" ]
        
//        AF.request.setValue("Basic ZTI3MjUzMTBhMzU1ZDE0MDhlYzFlMTBkOjNiZjMwNjYwNjY0ZGIwZjhjNTgyODM2Mw==", forHTTPHeaderField: "Authorization")
        
        
        AF.request(urora_url, method: .post, parameters: urora, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, AnyObject>
//                    print(json)
                    print("jsonDict = \(jsonDict)")
                    let phone = jsonDict!["phone"]
                    print("phone = \(phone!)")
                } catch {
                print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        /*
        .responseString { response in
            print("String:\(response.result)")
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                } catch {
                print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
         */
    }

/*
    public func signUp(
        email: String,
        username: String,
        password: String,
        profilePicture: Data?,
        completion: @escaping (Result<User, Error>) -> Void) {
            let newUser = User(username: username, email: email)
            //Create account
            auth.createUser(withEmail: email, password: password) { result, error in
                guard result != nil, error == nil else {
                    completion(.failure(AuthError.newUserCreation))
                    return
                }
                
                DatabaseManager.shared.createUser(newUser: newUser) { success in
                    if success {
                        StorageManager.shared.uploadProfilePicture(
                            username: username,
                            data: profilePicture
                        ) { uploadSuccess in
                            if uploadSuccess {
                                completion(.success(newUser))
                            }
                            else {
                                completion(.failure(AuthError.newUserCreation))
                            }
                        }
                    }
                    else {
                        completion(.failure(AuthError.newUserCreation))
                    }
                }
            }
        }
*/
    
    public func signOut(
        completion: @escaping (Bool) -> Void
    ) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
