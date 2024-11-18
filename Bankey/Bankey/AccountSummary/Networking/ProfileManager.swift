//
//  ProfileManager.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/29.
//

import Foundation

protocol ProfileManageable: AnyObject {
    func fetchProfile(forUserId userId: String) async throws -> Profile
}

enum NetworkError:Error {
    case serverError
    case decodingError
    case invalidURLError
}

struct Profile:Codable {
    let id: String
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class ProfileManager: ProfileManageable {

    func fetchProfile(forUserId userId: String) async throws -> Profile {
        let urlString = "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURLError
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.serverError
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let profile  = try decoder.decode(Profile.self, from: data)
            return profile
        } catch {
            throw NetworkError.decodingError
        }
    }
}
